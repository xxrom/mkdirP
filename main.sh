mkdirPP () {
  name=$1
  secondArg=$2

  prepareFolder () {
    echo "prepareFolder > '$name'"

    # create new dir
    mkdir "$name"

    # change folder to new just created
    cd $name

    # delete package.json
    rm -f package.json

    yarn init -y
  }

  prepareFiles () {
    prepareFolder

    echo "prepareFiles > Initing main.py + nodemon"

    # delete last line from package.json
    sed "$ d" ./package.json > ./package.json.temp
    # add scripts to package.json
    echo ',\n  "nodemonConfig": { "delay": "1" },\n  "scripts": \n  {\n        "dev": "nodemon --exec python3 main.py ./main.py" \n  }\n}' >> ./package.json.temp

    # # claning
    cp package.json.temp package.json
    rm -f package.json.temp

    # make main.py
    touch main.py

    # add code to main.py
    echo 'my = Solution()\nn = 0\ntrueAns=0\nans = my.X(n)\nprint("ans", ans, ans == trueAns)' >> ./main.py
  }

  initGit () {
    echo "initGit > name: '$name'"
    cR $name $secondArg
  }

  finish_mkdirPP () {
    echo # new line
    echo 'Done =)'
    echo # new line

    # run VScode
    code .

    yarn dev

    return 1
  }

  askGitIniting () {
    echo 'init GIT ? (y/n) '
    read isGitInit

    if [[ "$isGitInit" =~ ^[Yy]$ ]]
    then
      echo "> > > Init GIT!"
      initGit
      # ssh-add ~/.ssh/id_ed25519_xpom55mail
      cR $name $secondArg
    else
      echo "> > > Without GIT!"
      echo # new line
    fi
  }

  askNodemonIniting () {
    echo 'INIT WITH NODEMON ? (y/n) '
    read isInitNodemon

    if [[ "$isInitNodemon" =~ ^[Yy]$ ]]
    then
      prepareFiles
    else
      prepareFolder
      echo "> > > Empty folder"
    fi
  }

  if [ -z "$name" ]
  then
    echo "No mdkir name argument!"
    return 1
  fi

  if [ -z "$secondArg" ]
  then
    askNodemonIniting
    askGitIniting
  else

    if [[ "$secondArg" =~ ^-[Yy]$ || "$secondArg" == "gitBoth" ]]
    then
      echo "> > > Auto Init everything (gitHub + gitLab)"
      prepareFiles
      initGit
    else
      askNodemonIniting
      askGitIniting
    fi
  fi

  finish_mkdirPP
}