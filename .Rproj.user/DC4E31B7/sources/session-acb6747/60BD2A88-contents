lr.kde <- function(xnew, y, x, h, ncores = 1) {
  mod <- kernreg::kern_reg(xnew, y, x, h, type = "gauss", ncores = ncores)
  list( prob = mod, cl = round(mod) )
}

