
# How many packages are published on CRAN
# Inspired by:
# http://blog.revolutionanalytics.com/2015/06/how-many-packages-are-there-really-on-cran.html

types <- c("source", "win.binary", 
           "mac.binary", "mac.binary.mavericks")

CRANmirror <- "https://cloud.r-project.org/"

pdb <- lapply(types, function(x){
  cran <- contrib.url(repos = CRANmirror)
  available.packages(contriburl = cran)
})
names(pdb) <- types
str(pdb, max.level = 1)


# Number of available packages
sapply(pdb, nrow)

# Display first few packages for each type
pkgs <- sapply(pdb, rownames)
lapply(pkgs, head)
