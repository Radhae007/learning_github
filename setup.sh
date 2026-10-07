#!/usr/bin/env bash
# Git workshop setup: builds the practice repos locally. No GitHub needed.
# Run from inside an empty folder (e.g. ~/git-workshop). Safe to re-run:
# it deletes and rebuilds everything it creates.
#
# Windows: run this in Git Bash, not PowerShell or CMD.

set -e

REPOS="undo-1 undo-2 undo-3 undo-4 conflict-practice"

# Wipe any previous run
for d in $REPOS; do
  rm -rf "$d"gh
done

# Create a repo in $1 with local identity set and branch named main
new_repo() {
  mkdir "$1"
  cd "$1"
  git init -q
  git symbolic-ref HEAD refs/heads/main   # works on any git version
  git config user.name "Workshop Student"
  git config user.email "student@example.com"
  git config core.autocrlf false
}

# ---------------------------------------------------------------
# undo-1: edited a file, want it back (uncommitted change)
# ---------------------------------------------------------------
new_repo undo-1
cat > TASKS.md <<'EOF'
# Task 1
You edited notes.txt by mistake and want it back exactly as it was
in your last commit. Throw away the edit.

Check your work with: git status
EOF
printf 'Line one\nLine two\n' > notes.txt
git add .
git commit -q -m "Add notes and task"
printf 'Oops, this line should not be here\n' >> notes.txt
cd ..

# ---------------------------------------------------------------
# undo-2: staged the wrong file
# ---------------------------------------------------------------
new_repo undo-2
cat > TASKS.md <<'EOF'
# Task 2
You ran git add on passwords.txt by mistake. Unstage it so it is
NOT part of the next commit. Do not delete the file.

Check your work with: git status
EOF
echo "Hello from the app" > app.txt
git add .
git commit -q -m "Add app and task"
echo "admin:hunter2" > passwords.txt
git add passwords.txt
cd ..

# ---------------------------------------------------------------
# undo-3: typo in the last commit message
# ---------------------------------------------------------------
new_repo undo-3
cat > TASKS.md <<'EOF'
# Task 3
Your last commit message has a typo ("welcom"). Fix the message so
it reads "Add welcome page". Do not create a new commit.

Check your work with: git log --oneline
EOF
git add .
git commit -q -m "Add task file"
echo "<h1>Welcome</h1>" > welcome.html
git add .
git commit -q -m "Add welcom page"
cd ..

# ---------------------------------------------------------------
# undo-4: bad commit buried in history, revert it
# ---------------------------------------------------------------
new_repo undo-4
cat > TASKS.md <<'EOF'
# Task 4
One commit in this history added debug code that should not be
there. Undo that commit WITHOUT rewriting history (the other two
good commits must stay). Find it with git log --oneline.

Check your work with: git log --oneline and ls
EOF
git add .
git commit -q -m "Add task file"
echo "def add(a, b): return a + b" > math_utils.py
git add .
git commit -q -m "Add math utils"
echo "print('DEBUG: secret value =', 42)" > debug.py
git add .
git commit -q -m "Add debug code"
echo "# My project" > README.md
git add .
git commit -q -m "Add readme"
cd ..

# ---------------------------------------------------------------
# conflict-practice: merging feature-a into main will conflict
# ---------------------------------------------------------------
new_repo conflict-practice
cat > TASKS.md <<'EOF'
# Conflict exercise
1. Run: git merge feature-a
2. Git will report a conflict in greeting.txt. Run git status.
3. Open greeting.txt, decide what line 2 should say, and delete the
   <<<<<<<, =======, >>>>>>> marker lines.
4. git add greeting.txt
5. git commit
6. Check the result with: git log --graph --oneline
EOF
printf 'Hello\nI like tea\nGoodbye\n' > greeting.txt
git add .
git commit -q -m "Add greeting"
git switch -q -c feature-a
printf 'Hello\nI like coffee\nGoodbye\n' > greeting.txt
git commit -q -am "Change line 2 to coffee"
git switch -q main
printf 'Hello\nI like juice\nGoodbye\n' > greeting.txt
git commit -q -am "Change line 2 to juice"
cd ..

echo
echo "Done. Created: $REPOS"
echo "cd into any folder and read TASKS.md to start."
