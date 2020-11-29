if (( $# < 1 ))
then
	echo "Please specify parallelism as a command argument"
    exit 1
fi
/software/matlabR2016a/bin/matlab -nodisplay -nosplash -nodesktop -r "daddagenerator($1); exit;"
python3 makemult.py $1
