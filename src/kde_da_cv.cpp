//[[Rcpp::plugins(openmp)]]
#include <Rcpp.h>
#include <algorithm>
#include <cmath>
#include <limits>
#include <vector>

#ifdef _OPENMP
#include <omp.h>
#endif

using std::vector;

// Internal function, called by kde_da() in R, which also checks the input.
//
// H is a max(groups) x m matrix of bandwidths: column k holds the bandwidth of
// each group for the k-th fit.
//
// Returns a list with
//   class : length(xnew) x m integer matrix of predicted groups
//   kde   : list of m matrices, each length(xnew) x max(groups), whose entry
//           [i, g] is the kernel density estimate of group g at xnew[i].
//
// [[Rcpp::export(.kde_da_cpp)]]
Rcpp::List kde_da_cpp(const Rcpp::NumericVector &xnew,
                      const Rcpp::IntegerVector &groups,
                      const Rcpp::NumericVector &x,
                      const Rcpp::NumericMatrix &H,
                      int ncores = 1) {
  const int sizeOld = x.size();
  const int sizeNew = xnew.size();
  const int numGroups = H.nrow();
  const int numH = H.ncol();

  if (groups.size() != sizeOld)
    Rcpp::stop("'groups' and 'x' must have the same length.");

  vector<vector<double>> groupsMap(numGroups);
  for (int i = 0; i < sizeOld; ++i) {
    if (groups[i] == NA_INTEGER || groups[i] < 1 || groups[i] > numGroups)
      Rcpp::stop("'groups' must contain integers between 1 and the number of groups.");
    groupsMap[groups[i] - 1].push_back(x[i]);
  }

  // Stored by group: entry [g * numH + k] belongs to group g and fit k.
  vector<double> hval(numGroups * (std::size_t)numH);
  vector<double> logh(hval.size()), inv2h2(hval.size());
  for (int g = 0; g < numGroups; ++g) {
    for (int k = 0; k < numH; ++k) {
      const std::size_t id = g * (std::size_t)numH + k;
      hval[id] = H(g, k);
      logh[id] = std::log(hval[id]);
      inv2h2[id] = -0.5 / (hval[id] * hval[id]);
    }
  }

  // All R objects are created here, before the parallel region.
  Rcpp::IntegerMatrix cl(Rcpp::no_init(sizeNew, numH));
  int *p_cl = cl.begin();
  Rcpp::List kde(numH);
  vector<double *> p_kde(numH);
  for (int k = 0; k < numH; ++k) {
    Rcpp::NumericMatrix m(Rcpp::no_init(sizeNew, numGroups));
    p_kde[k] = m.begin();
    kde[k] = m;
  }

  const double *p_xnew = xnew.begin();
  const double sqrt2pi = std::sqrt(2.0 * M_PI);
  const double inf = std::numeric_limits<double>::infinity();

#ifdef _OPENMP
#pragma omp parallel num_threads(ncores > 0 ? ncores : 1)
#endif
  {
    vector<double> acc(numH), best(numH);
    vector<int> bestId(numH);

#ifdef _OPENMP
#pragma omp for schedule(dynamic)
#endif
    for (int j = 0; j < sizeNew; ++j) {
      const double xj = p_xnew[j];

      if (!std::isfinite(xj)) {
        for (int k = 0; k < numH; ++k) {
          p_cl[j + k * sizeNew] = NA_INTEGER;
          for (int g = 0; g < numGroups; ++g)
            p_kde[k][j + g * (std::size_t)sizeNew] = NA_REAL;
        }
        continue;
      }

      std::fill(best.begin(), best.end(), -inf);
      std::fill(bestId.begin(), bestId.end(), 0);

      for (int g = 0; g < numGroups; ++g) {
        const vector<double> &pts = groupsMap[g];
        const int m = pts.size();
        const double *ginv = inv2h2.data() + g * (std::size_t)numH;
        const double *glogh = logh.data() + g * (std::size_t)numH;
        const double *gh = hval.data() + g * (std::size_t)numH;

        if (m == 0) {
          for (int k = 0; k < numH; ++k)
            p_kde[k][j + g * (std::size_t)sizeNew] = 0.0;
          continue;
        }

        // Subtract the smallest squared distance within the group: its nearest
        // point then has kernel 1, so the sum of the kernels cannot underflow.
        double minSq = inf;
        for (int i = 0; i < m; ++i) {
          const double d = xj - pts[i];
          if (d * d < minSq)
            minSq = d * d;
        }

        std::fill(acc.begin(), acc.end(), 0.0);
        for (int i = 0; i < m; ++i) {
          const double d = xj - pts[i];
          const double dsq = d * d - minSq;
          for (int k = 0; k < numH; ++k)
            acc[k] += std::exp(dsq * ginv[k]);
        }

        for (int k = 0; k < numH; ++k) {
          // With empirical priors, pi_g * f_g(x) = sum(K) / (n * h_g * sqrt(2 pi)).
          // The bandwidths may differ between groups, so compare on the log scale.
          const double shift = minSq * ginv[k];
          const double score = std::log(acc[k]) + shift - glogh[k];
          if (score > best[k]) {
            best[k] = score;
            bestId[k] = g;
          }
          p_kde[k][j + g * (std::size_t)sizeNew] =
              acc[k] * std::exp(shift) / (m * gh[k] * sqrt2pi);
        }
      }

      for (int k = 0; k < numH; ++k)
        p_cl[j + k * sizeNew] = bestId[k] + 1;
    }
  }

  return Rcpp::List::create(Rcpp::Named("class") = cl,
                            Rcpp::Named("kde") = kde);
}
