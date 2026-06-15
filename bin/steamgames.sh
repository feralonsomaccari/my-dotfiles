for f in ~/.local/share/Steam/steamapps/appmanifest_*.acf; do
appid=$(grep '"appid"' "$f" | head -n1 | sed 's/[^0-9]//g')
name=$(grep '"name"' "$f" | head -n1 | cut -d\" -f4)
printf "\e[32m%-10s\e[0m %s\n" "$appid" "$name"
done
