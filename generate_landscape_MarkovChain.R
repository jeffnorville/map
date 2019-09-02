# from SO: https://gis.stackexchange.com/questions/16136/randomly-altering-raster-map-of-habitat-types
#
# Make a transition from state `x` using a kernel having `k.ft` as
# its Fourier transform.
#
transition <- function(x, k.ft, q=0.1) {
  k <- zapsmall(Re(fft(k.ft * fft(x), inverse=TRUE))) / length(x)
  matrix(runif(length(k)) > q^k, nrow=nrow(k))
}
#
# Create the zeroth generation and the fft of a transition kernel.
#
n.row <- 2^7 # FFT is best with powers of 2
n.col <- 2^7
kernel <- matrix(0, nrow=n.row, ncol=n.col)
kernel[1:3, 1:3] <- 1/9
kernel.f <- fft(kernel)

set.seed(17)
x <- matrix(sample(c(0,1), n.row*n.col, replace=TRUE, prob=c(599, 1)), n.row)
#
# Prepare to run multiple simulations.
#
y.list <- list()
parameters <- c(.25, .2, .15, .1, .05)
#
# Perform and benchmark the simulations.
#
i <- 0
system.time({
  for (q in parameters) {
    y <- x
    for (generation in 1:10) {
      y <- transition(y, kernel.f, q)
    }
    y.list[[i <- i+1]] <- y
  }
})
#
# Display the results.
#    
par(mfrow=c(1,length(parameters)))
invisible(sapply(1:length(parameters), 
                 function(i) image(y.list[[i]], 
                                   col=c("White", "Black"),
                                   main=parameters[i])))

