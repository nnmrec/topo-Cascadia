# just run this script from a directory containing a series of images 

CASE_DIR=.

BASE_FILENAME=$CASE_DIR/horizontal-speed__ocean_his_
ffmpeg -i $BASE_FILENAME%04d.png -threads 16 -c:v libvpx -c:a libvorbis -pix_fmt yuv420p -quality good -b:v 2M -crf 5 -vf "scale=trunc(in_w/2)*2:trunc(in_h/2)*2" $CASE_DIR/spd.webm

BASE_FILENAME=$CASE_DIR/tke__ocean_his_
ffmpeg -i $BASE_FILENAME%04d.png -threads 16 -c:v libvpx -c:a libvorbis -pix_fmt yuv420p -quality good -b:v 2M -crf 5 -vf "scale=trunc(in_w/2)*2:trunc(in_h/2)*2" $CASE_DIR/tke.webm

BASE_FILENAME=$CASE_DIR/eps__ocean_his_
ffmpeg -i $BASE_FILENAME%04d.png -threads 16 -c:v libvpx -c:a libvorbis -pix_fmt yuv420p -quality good -b:v 2M -crf 5 -vf "scale=trunc(in_w/2)*2:trunc(in_h/2)*2" $CASE_DIR/eps.webm

BASE_FILENAME=$CASE_DIR/spd-tke-eps__ocean_his_
ffmpeg -i $BASE_FILENAME%04d.png -threads 16 -c:v libvpx -c:a libvorbis -pix_fmt yuv420p -quality good -b:v 2M -crf 5 -vf "scale=trunc(in_w/2)*2:trunc(in_h/2)*2" $CASE_DIR/spd-tke-eps.webm

cp *.webm /mnt/data-RAID-1/Dropboxes/danny/Dropbox/uw/DISSERTATION/2017/shared_with_Alberto/2017_papers_Sale_Aliseda/paper2_nesting_in_ROMS/figures/
cp *.fig /mnt/data-RAID-1/Dropboxes/danny/Dropbox/uw/DISSERTATION/2017/shared_with_Alberto/2017_papers_Sale_Aliseda/paper2_nesting_in_ROMS/figures/