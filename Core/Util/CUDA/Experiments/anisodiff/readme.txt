Usage:

diff = anisodiff(im, niter, kappa, lambda, option);

 Arguments:
         im     - input image
         niter  - number of iterations.
         kappa  - conduction coefficient
         lambda - max value of .25 for stability
         option - 1 Perona Malik diffusion equation No 1
                  2 Perona Malik diffusion equation No 2

 Returns:
         diff   - diffused image.



  Example:

im = imread('pout.tif');
im = im2double(im);
diff = anisodiff(im, 100, .015, .25, 1);
diff2 = anisodiff(im, 100, .015, .25, 2);
figure;
subplot(1,3,1);imshow(im,[]);
subplot(1,3,2);imshow(diff,[]);
subplot(1,3,3);imshow(diff2,[]);