. ap.setenv
cmake .
make -j4
bsub -W 00:02 -n 16 mpirun ./main --nx 192 --ny 128 --nz 192 --bs 16 --layers 1 --new_recolor 1 --file_prefix 1 a.conf
