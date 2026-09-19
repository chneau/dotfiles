@echo off
:: CMD Dotfiles & Aliases for Windows
:: Automatically loaded via HKCU\Software\Microsoft\Command Processor\AutoRun

:: ==============================================================================
:: 1. Custom Prompt (Matching PowerShell & Bash)
:: [OK] HH:mm:ss user@host drive:\path >
:: ==============================================================================
set PROMPT=$E[1;32m[OK]$E[0m $E[1;37m$T$H$H$H$H$H$H$E[0m $E[1;32m%USERNAME%@%COMPUTERNAME%$E[0m $E[1;34m$P$E[0m $E[1;34m$G$E[0m$S

:: ==============================================================================
:: 2. Environment Variables (from .profile)
:: ==============================================================================
set DOCKER_BUILDKIT=1
set BUILDX_EXPERIMENTAL=1
set NODE_OPTIONS=--max_old_space_size=4096
set CARGO_NET_GIT_FETCH_WITH_CLI=true
set DOTNET_WATCH_RESTART_ON_RUDE_EDIT=true
set NPM_CONFIG_YES=true
set NPM_CONFIG_FUND=false
set BUN_CONFIG_NO_CLEAR_TERMINAL_ON_RELOAD=1
set DO_NOT_TRACK=1
set FORCE_COLOR=1
set BAT_PAGING=never
set BAT_STYLE=plain
set BAT_TABS=2
set DOTNET_CLI_TELEMETRY_OPTOUT=1

:: ==============================================================================
:: 3. Navigation
:: ==============================================================================
doskey ..=cd ..
doskey ...=cd ..\..
doskey ....=cd ..\..\..

:: ==============================================================================
:: 4. File System & Utilities
:: ==============================================================================
doskey l=dir /w $*
doskey la=dir /a /o:gn $*
doskey ll=dir /a /o:gn $*
doskey lh=dir /a /o:gn $*
doskey ls=dir /o:gn $*
doskey grep=findstr /i $*
doskey diff=git diff --no-index $*

:: ==============================================================================
:: 5. Git Shortcuts
:: ==============================================================================
doskey ga=git add $*
doskey gb=git branch --sort=-committerdate -vv $*
doskey gba=git branch --sort=-committerdate -vva $*
doskey gc=git commit -v $*
doskey gca=git commit . -v $*
doskey gcam=git commit -a -m $*
doskey gcamp=git commit -a -m $* $T git push
doskey gsp=git add -A $T git commit -m $* $T git push
doskey gcl=git clone $*
doskey gco=git checkout $*
doskey gcom=git checkout master $*
doskey gd=git diff $*
doskey gigit=git clone --depth=1 $*
doskey gl=git pull $*
doskey gla=git pull --all $*
doskey glom=git pull origin master $*
doskey glog=git log --graph --pretty=format:"%%Cred%%h%%Creset %%an: %%s - %%C(yellow)%%d%%Creset %%Cgreen(%%cr)%%Creset" --abbrev-commit --date=relative $*
doskey gp=git push $*
doskey gs=git status -sb $*
doskey gsc=git switch -c $*
doskey gsw=git switch $*
doskey gsta=git stash push $*
doskey gstd=git stash drop $*
doskey gstl=git stash list $*
doskey gstp=git stash pop $*
doskey grba=git rebase --abort $*
doskey grbc=git rebase --continue $*
doskey gitclean=git reflog expire --expire=now --all ^& git repack -ad ^& git prune ^& git fetch --prune --prune-tags ^& git clean -ffdx
doskey gitnewfresh=git checkout --orphan $*
doskey gitrmtag=git push -d origin $*

:: ==============================================================================
:: 6. Docker & Kubernetes
:: ==============================================================================
doskey d=docker $*
doskey db=docker build --pull --tag $*
doskey dbpush=docker build --pull --push --tag $*
doskey dbtest=docker build --pull --tag test . $*
doskey dc=docker compose $*
doskey de=docker exec -it $*
doskey di=docker images $*
doskey dl=docker logs --tail 40 -f $*
doskey dps=docker ps $*
doskey ds=docker stats $*
doskey dsdf=docker system df $*
doskey dt=docker run --rm -it $*

doskey k=kubectl $*
doskey ka=kubectl apply -f $*
doskey kak=kubectl apply -k $*
doskey kar=kubectl api-resources $*
doskey kconf=kubectl config view --raw $*
doskey kdes=kubectl describe $*
doskey kdestroy=kubectl delete --grace-period=0 --force $*
doskey kdn=kubectl describe node $*
doskey ke=kubectl exec -ti $*
doskey kex=kubectl explain $*
doskey kg=kubectl get $*
doskey kga=kubectl get all,ingress $*
doskey kgaa=kubectl get all,ingress --all-namespaces $*
doskey kgd=kubectl get deployment,statefulset,daemonset,cronjob $*
doskey kge=kubectl get events $*
doskey kgea=kubectl get events --all-namespaces $*
doskey kgia=kubectl get ingress --all-namespaces $*
doskey kgpa=kubectl get pods --all-namespaces $*
doskey kgs=kubectl get secret $*
doskey kk=kubectl kustomize $*
doskey kl=kubectl logs -f --tail=40 $*
doskey kll=kubectl logs -f --tail=40 --timestamps --prefix $*
doskey kpf=kubectl port-forward $*
doskey kr=kubectl rollout $*
doskey krr=kubectl rollout restart $*
doskey ktn=kubectl top nodes $*
doskey ktp=kubectl top pods --sort-by=memory $*
doskey ktpa=kubectl top pods --all-namespaces --sort-by=memory $*
doskey kw=kubectl get po -w $*

:: ==============================================================================
:: 7. Language Tools & Runtimes (Bun, Node, Go, Python/uv, DotNet, Zig)
:: ==============================================================================
doskey b=bun $*
doskey bbmd=bun build --metafile-md $*
doskey bbx=bun --bun x $*
doskey bcp=bun --cpu-prof-md $*
doskey bcphp=bun --cpu-prof-md --heap-prof-md $*
doskey bd=bun run dev $*
doskey bfmt=biome check --write --unsafe . $*
doskey bh=bun --hot --no-clear-screen $*
doskey bhp=bun --heap-prof-md $*
doskey bi=bun install --force --no-save $*
doskey bic=biome check --write --unsafe . $*
doskey bo=bun outdated $*
doskey br=bun run $*
doskey brp=bun run --parallel $*
doskey brs=bun run --sequential $*
doskey bs=bun start $*
doskey bw=bun --watch --no-clear-screen $*
doskey bx=bun x $*
doskey bxb=bun --bun x $*

doskey npme=npm exec --yes -- $*
doskey ncup=npm-check-updates --upgrade --install=always --packageManager=bun --deep $*
doskey npmup=npm-check-updates --deep --upgrade --install=always --packageManager=bun $*
doskey tsfmt=biome check --write --unsafe . $*
doskey tslint=tsc --noEmit --project . $*

doskey goi=go install $*
doskey gotest=go test -cover -count=1 $*
doskey gotestfast=go test -v ./... $*
doskey gotidy=go mod tidy ^& go mod verify

doskey pipi=uv pip install --upgrade $*
doskey pipig=uv tool install $*
doskey pipup=uv pip install --upgrade $*
doskey pipupg=uv tool upgrade --all $*
doskey servepy=uv run python -m http.server $*
doskey webshare=uv run python -m http.server $*

doskey dotnetfmt=dotnet csharpier . $*
doskey dotnetup=dotnet outdated --upgrade $*

doskey z=zig $*
doskey zb=zig build $*
doskey zbr=zig build run $*
doskey zr=zig run $*

:: ==============================================================================
:: 8. AI Coding Assistants & CLI Tools
:: ==============================================================================
doskey cl=claude $*
doskey cly=claude --dangerously-skip-permissions $*
doskey agyy=agy --dangerously-skip-permissions $*
doskey agenty=agent --yolo $*
doskey codexy=codex --dangerously-bypass-approvals-and-sandbox $*
doskey ocy=opencode --auto $*
doskey opencodey=opencode --auto $*
doskey kiloy=kilo --auto $*
doskey hermesy=hermes --yolo $*
doskey reasonixy=reasonix --permission-mode bypassPermissions $*
doskey ry=reasonix --permission-mode bypassPermissions --yolo $*
doskey rw=reasonix web $*
doskey ireasonix=bun i -g reasonix@latest $*
doskey imcode=bun i -g @minimax-ai/code $*
doskey icf=bun i -g cf $*
doskey icharlie=bun i -g charlie-git@latest $*
doskey icline=bun i -g cline $*
doskey idsh=bun i -g @deepseek-ai/dsh@latest $*
doskey ijsdoc-scribe=bun i -g jsdoc-scribe@latest $*
doskey iposthogcli=bun i -g @posthog/cli@latest $*
doskey iskillsmattpocock=bunx skills add mattpocock/skills $*
doskey ihermes=powershell -c "irm https://hermes-agent.nousresearch.com/install.ps1 | iex"
doskey ipi=powershell -c "irm https://pi.dev/install.ps1 | iex"
doskey ix=bun install --force --global @chneau/x

:: ==============================================================================
:: 9. Media & Utilities
:: ==============================================================================
doskey yt=yt-dlp $*
doskey ymp4=yt-dlp -S res,ext:mp4:m4a --recode mp4 $*
doskey ymp4s=yt-dlp -S res,ext:mp4:m4a --recode mp4 --embed-subs --sub-lang en --add-metadata --convert-subs srt --embed-thumbnail $*
doskey ymp3=yt-dlp --restrict-filenames --continue --ignore-errors --download-archive downloaded.txt --no-post-overwrites --no-overwrites --extract-audio --audio-format mp3 --output "%%(title)s.%%(ext)s" $*
doskey lg=lazygit $*
doskey rtk=rtk $*
