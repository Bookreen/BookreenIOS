ROOT='/Users/bullhead/IdeaProjects/Book/bookreen'
SCRIPT_INPUT_FILE_0=$ROOT'/Bookreen/Localizable/en.lproj/Localizable.strings'
SCRIPT_INPUT_FILE_1=$ROOT'/Bookreen/generated/S.swift'

touch "$SCRIPT_INPUT_FILE_1"
echo "// Auto Generated" >"$SCRIPT_INPUT_FILE_1"
echo "import Foundation" >>"$SCRIPT_INPUT_FILE_1"
echo "class S {" >>"$SCRIPT_INPUT_FILE_1"

while IFS='' read -r line || [[ -n "$line" ]]; do
  if [[ ${line:0:1} == "\"" ]]; then
    line=$(sed -E 's/[\";]+//g' <<<"$line")
    IFS='=' read -ra li <<<"$line"
    key=$(gsed -E 's/_(.)/\U\1/g' <<<"$li")
    li=`echo $li | xargs`
    echo "      static let $key = \"$li\"" >>"$SCRIPT_INPUT_FILE_1"
  fi
done <"$SCRIPT_INPUT_FILE_0"

#append } in last
echo "}" >>"$SCRIPT_INPUT_FILE_1"
