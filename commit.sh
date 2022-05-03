d=$(date)
sd "Date: [^']+" "Date: $d" flake.nix
git add * && \
    git commit -m  "Update $d" # && \
    # git push
