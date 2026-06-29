//[[Rcpp::plugins(openmp)]]
#include <Rcpp.h>
#include <cmath>
#include <vector>

#ifdef _OPENMP
#include <omp.h>
#endif

using std::vector;

// [[Rcpp::export]]
Rcpp::IntegerMatrix kde_da(const Rcpp::NumericVector &xnew,
                                  const Rcpp::IntegerVector &groups,
                                  const Rcpp::NumericVector &x,
                                  const Rcpp::NumericVector &h,
                                  int ncores = 1) {
  int numGroups = Rcpp::max(groups);
  int sizeOld = x.size();
  int sizeNew = xnew.size();
  int numH = h.size();

  vector<double> frequencies(numGroups, 0.0);
  vector<vector<double>> groupsMap(numGroups);
  for (int i{}; i < sizeOld; ++i) {
    int groupId = groups[i] - 1;
    frequencies[groupId] += 1.0;
    groupsMap[groupId].push_back(x[i]);
  }

  for (int gId{}; gId < numGroups; ++gId) {
    frequencies[gId] /= static_cast<double>(sizeOld);
  }

  vector<vector<double>> scaleTerms(numH, vector<double>(numGroups));
  vector<double> inv2h2(numH);
  for (int hId{}; hId < numH; ++hId) {
    double hcurr = h[hId];
    inv2h2[hId] = -0.5 / (hcurr * hcurr);
    for (int gId{}; gId < numGroups; ++gId) {
      int m = groupsMap[gId].size();
      scaleTerms[hId][gId] = m > 0 ? frequencies[gId] / (m * hcurr) : 0.0;
    }
  }

  const double *p_xnew = &xnew[0];
  Rcpp::IntegerMatrix cl(Rcpp::no_init(sizeNew, numH));

#ifdef _OPENMP
#pragma omp parallel for schedule(dynamic) if (ncores > 1) num_threads(ncores)
#endif
  for (int j = 0; j < sizeNew; ++j) {
    double xj = p_xnew[j];

    vector<vector<double>> accumulated_A(numH, vector<double>(numGroups, 0.0));

    for (int g = 0; g < numGroups; ++g) {
      const auto &subVec = groupsMap[g];
      int m = subVec.size();
      if (m == 0)
        continue;
      const double *ptr = subVec.data();

      for (int i = 0; i < m; ++i) {
        double diff = xj - ptr[i];
        double diff_sq = diff * diff;

        for (int hId = 0; hId < numH; ++hId) {
          accumulated_A[hId][g] += expf(diff_sq * inv2h2[hId]);
        }
      }
    }

    for (int hId = 0; hId < numH; ++hId) {
      double maxVal{-1.0};
      int maxIdx{};
      const auto &scaleTermsCur = scaleTerms[hId];

      for (int g = 0; g < numGroups; ++g) {
        double density = accumulated_A[hId][g] * scaleTermsCur[g];
        if (density > maxVal) {
          maxVal = density;
          maxIdx = g;
        }
      }
      cl(j, hId) = maxIdx + 1;
    }
  }

  return cl;
}
