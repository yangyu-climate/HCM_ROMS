export PATH=/home/PublicSoftware/matlab-R2017B/bin:$PATH
nohup matlab -nojvm -nodisplay -nosplash -nodesktop < Run.m 1>running.log 2>running.err &
