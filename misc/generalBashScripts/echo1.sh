# echo $1
filename=$(basename -- "$1")
#filename="$1"
extension="${filename##*.}"
filename="${filename%.*}"
# echo "Fm '$filename'"

convert $1 -resize 1086x724 ../2020aprilSize1024/$filename.jpg
ls ../2020aprilSize1024/$filename.jpg
