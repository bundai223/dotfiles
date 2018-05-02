
db_download()
{
  target=${1}
  target_filename=$(basename ${target} | sed "s/?dl=0//g")
  decoded_name=$(urldecode $target_filename)
  wget ${target} -O ${decoded_name}
}
