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
doskey egrep=findstr /i /r $*
doskey fgrep=findstr /i /c:$*
doskey gr=powershell -NoLogo -Command gr $*
doskey grephere=findstr /s /i /n /w /c:$* .\*
doskey findtext=findstr /s /i /n /c:"$*" .\*
doskey findfile=dir /s /b $*
doskey diff=git diff --no-index $*

doskey aihelp=powershell -c "aihelp"
doskey ai-help=powershell -NoLogo -Command aihelp
doskey clihelp=powershell -c "clihelp"
doskey cli-help=powershell -NoLogo -Command clihelp
doskey tmuxhelp=powershell -NoLogo -Command tmuxhelp
doskey tmux-help=powershell -NoLogo -Command tmuxhelp
doskey uploadhelp=powershell -NoLogo -Command uploadhelp
doskey upload-help=powershell -NoLogo -Command uploadhelp

doskey bench=hyperfine $*
doskey hf=hyperfine $*
doskey cc=concurrently --prefix-colors=auto $*
doskey catfull=bat --style=full $*
doskey fk=fkill --force $*
doskey oc=code -a . $*
doskey bverbosefetch=set "BUN_CONFIG_VERBOSE_FETCH=curl" ^& $* ^& set "BUN_CONFIG_VERBOSE_FETCH="

doskey cpuinfo=powershell -NoLogo -Command cpuinfo
doskey free=powershell -NoLogo -Command free
doskey meminfo=powershell -NoLogo -Command meminfo
doskey ff=powershell -NoLogo -Command ff
doskey psg=powershell -NoLogo -Command psg $*
doskey pscpu=powershell -NoLogo -Command pscpu
doskey pscpu10=powershell -NoLogo -Command pscpu10
doskey psmem=powershell -NoLogo -Command psmem
doskey psmem10=powershell -NoLogo -Command psmem10
doskey df=powershell -NoLogo -Command df
doskey du=powershell -NoLogo -Command du $*
doskey diskspace=powershell -NoLogo -Command diskspace $*
doskey e=powershell -NoLogo -Command e
doskey u=powershell -NoLogo -Command u
doskey lo=powershell -NoLogo -Command lo
doskey lld=powershell -NoLogo -Command lld
doskey ct=powershell -NoLogo -Command "$input | ct"
doskey hs=doskey /history ^| findstr $*
doskey path=powershell -NoLogo -Command path
doskey stripcolors=powershell -NoLogo -Command "$input | stripcolors"
doskey tobase64=powershell -NoLogo -Command tobase64
doskey genpwd=powershell -NoLogo -Command genpwd
doskey now=time /t
doskey nowdate=date /t
doskey nowtime=time /t
doskey ps=tasklist $*
doskey mkcdir=powershell -NoLogo -Command mkcdir $*
doskey refresh=call "%USERPROFILE%\.profile.cmd"

:: Load .env into the current cmd session
doskey ee=for /f "usebackq eol=# tokens=1,* delims==" %a in (.env) do set "%a=%b"
doskey exportenv=for /f "usebackq eol=# tokens=1,* delims==" %a in (.env) do set "%a=%b"

:: Archive extraction and 72h uploads are implemented in .profile.ps1
doskey extract=powershell -NoLogo -Command extract $*
doskey transfer=powershell -NoLogo -Command "$input | transfer $*"

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
:: Delegate to the PowerShell implementation (.profile.ps1) so cmd gets the same
:: local-only tag pruning and worktree cleanup logic in one place.
doskey gitclean=powershell -NoLogo -Command gitclean $*
doskey gitcleanf=powershell -NoLogo -Command gitcleanf $*
doskey gitcleanr=powershell -NoLogo -Command gitcleanr $*
doskey gitnewfresh=git checkout --orphan $*
doskey gitrmtag=git push -d origin $*
doskey gitmessage=powershell -NoLogo -Command gitmessage
doskey gitget=powershell -NoLogo -Command gitget $*
doskey gitgetc=powershell -NoLogo -Command gitgetc $*
doskey gg=powershell -NoLogo -Command gg $*
doskey gpm=powershell -NoLogo -Command gpm $*
doskey gpcb=powershell -NoLogo -Command gpcb $*
doskey grm=powershell -NoLogo -Command grm
doskey grb=powershell -NoLogo -Command grb
doskey gundopush=git push -f origin HEAD^:master $*
doskey goget=powershell -NoLogo -Command goget $*
doskey gols=powershell -NoLogo -Command gols
doskey gocd=powershell -NoLogo -Command gocd $*
doskey goinst=powershell -NoLogo -Command goinst $*
doskey goup=powershell -NoLogo -Command goup
doskey gobuild=powershell -NoLogo -Command gobuild $*
doskey genuuid=powershell -NoLogo -Command genuuid
doskey igit=powershell -NoLogo -Command igit

:: GPG
doskey gpgexport=gpg --armor --export $*
doskey gpggit=git config --global user.signingkey $*
doskey gpglist=gpg --list-secret-keys --keyid-format LONG
doskey gpgnew=gpg --default-new-key-algo rsa4096 --gen-key

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
doskey ddown=powershell -NoLogo -Command ddown
doskey dkill=powershell -NoLogo -Command dkill
doskey dkilla=powershell -NoLogo -Command dkilla
doskey dprune=docker system prune --force --volumes ^& docker volume prune --force
doskey dprunea=docker system prune --force --volumes --all ^& docker volume prune --force --all
doskey drm=powershell -NoLogo -Command drm
doskey dsi=docker service inspect --pretty $*
doskey dsl=docker service logs -f $*
doskey dsls=docker service ls --tail 40 $*
doskey dsd=docker stack down $*
doskey dsu=docker stack up -c $*
doskey dtest=docker run --rm -it --name test --hostname test $*
doskey doh=docker history $*
doskey dup=powershell -NoLogo -Command dockerup
doskey dockerup=docker run --pull=always --rm -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower --cleanup --remove-volumes --debug --run-once
doskey dwatch=docker run --pull=always -d --restart=always --name=watchtower -v=/var/run/docker.sock:/var/run/docker.sock:ro containrrr/watchtower --cleanup --remove-volumes
doskey dnd=docker run --rm -it --pull=always --name=netdata --pid=host --network=host -v netdataconfig:/etc/netdata -v netdatalib:/var/lib/netdata -v netdatacache:/var/cache/netdata -v /:/host/root:ro,rslave -v /etc/passwd:/host/etc/passwd:ro -v /etc/group:/host/etc/group:ro -v /etc/localtime:/etc/localtime:ro -v /proc:/host/proc:ro -v /sys:/host/sys:ro -v /etc/os-release:/host/etc/os-release:ro -v /var/log:/host/var/log:ro -v /var/run/docker.sock:/var/run/docker.sock:ro -v /run/dbus:/run/dbus:ro --cap-add SYS_PTRACE --cap-add SYS_ADMIN --security-opt apparmor=unconfined --no-healthcheck netdata/netdata
doskey dndd=docker run --detach --pull=always --name=netdata --pid=host --network=host -v netdataconfig:/etc/netdata -v netdatalib:/var/lib/netdata -v netdatacache:/var/cache/netdata -v /:/host/root:ro,rslave -v /etc/passwd:/host/etc/passwd:ro -v /etc/group:/host/etc/group:ro -v /etc/localtime:/etc/localtime:ro -v /proc:/host/proc:ro -v /sys:/host/sys:ro -v /etc/os-release:/host/etc/os-release:ro -v /var/log:/host/var/log:ro -v /var/run/docker.sock:/var/run/docker.sock:ro -v /run/dbus:/run/dbus:ro --restart always --cap-add SYS_PTRACE --cap-add SYS_ADMIN --security-opt apparmor=unconfined --no-healthcheck netdata/netdata
doskey dnekoff=docker run --pull=always --rm -it --name=neko --shm-size=2gb --net=host --env=NEKO_DESKTOP_SCREEN=1920x1080@30 --env=NEKO_MEMBER_MULTIUSER_USER_PASSWORD=c --env=NEKO_MEMBER_MULTIUSER_ADMIN_PASSWORD=cc --env=NEKO_WEBRTC_EPR=52000-52100 --env=NEKO_WEBRTC_ICELITE=1 ghcr.io/m1k1o/neko/firefox

:: Docker commands that need path/quoting logic live in .profile.ps1
doskey dcps=powershell -NoLogo -Command dcps $*
doskey dc9router=powershell -NoLogo -Command dc9router
doskey dc9routerup=powershell -NoLogo -Command dc9routerup
doskey dcb=powershell -NoLogo -Command dcb
doskey dcode=powershell -NoLogo -Command dcode
doskey dfirefox=powershell -NoLogo -Command dfirefox
doskey dff=powershell -NoLogo -Command dfirefox
doskey djellyfin=powershell -NoLogo -Command djellyfin
doskey dk=powershell -NoLogo -Command dk
doskey dm=powershell -NoLogo -Command dm
doskey dn=powershell -NoLogo -Command dn
doskey dpihole=powershell -NoLogo -Command dpihole
doskey dsave=powershell -NoLogo -Command dsave $*
doskey dlog=powershell -NoLogo -Command dlog
doskey dtf=powershell -NoLogo -Command dtf
doskey dockertags=powershell -NoLogo -Command dockertags $*
doskey iproxy=powershell -NoLogo -Command iproxy

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
doskey kctx=kubectx $*
doskey kns=kubens $*
doskey hla=helm list --all-namespaces $*
doskey kd=kubectl diff -f $*
doskey kdk=kubectl diff -k $*
doskey kdebug=kubectl run -i --tty --rm debug --image=alpine --restart=Never -- sh
doskey kcron=echo kubectl create job --from=cronjob/dump manual-001
doskey kgapi=kubectl get apiservices $*
doskey knt=kubent $*
doskey kenv=kubectl set env pods --all --list $*
doskey kkill=kubectl delete pods --grace-period=0 --force --all $*
doskey klall=kubectl stern --max-log-requests=999 --since=1s $*
doskey klallall=kubectl stern --all-namespaces --max-log-requests=999 --since=1s $*
doskey klall_old=kubectl logs --selector=pod-template-hash --all-containers --ignore-errors --follow --max-log-requests=999 --timestamps --prefix $*
doskey kmip=kubectl run debug --stdin --tty --rm --image=alpine --restart=Never -- sh -ci "wget -qO- api.ipify.org && echo"
doskey krewig=kubectl krew install ns ctx stern ^& kubectl krew upgrade
doskey ks0=kubectl scale --replicas=0 deployment --all ^& kubectl scale --replicas=0 statefulset --all
doskey ks1=kubectl scale --replicas=1 deployment --all ^& kubectl scale --replicas=1 statefulset --all
doskey kdecode=powershell -NoLogo -Command kdecode $*
doskey kclean=powershell -NoLogo -Command kclean
doskey ktest=powershell -NoLogo -Command ktest $*

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
doskey dotnethttps=dotnet dev-certs https --clean ^& dotnet dev-certs https --trust
doskey dotneti=powershell -NoLogo -Command dotneti $*
doskey dotnetig=powershell -NoLogo -Command dotnetig
doskey dotnetup=dotnet outdated --upgrade $*

doskey z=zig $*
doskey zb=zig build $*
doskey zbr=zig build run $*
doskey zr=zig run $*

:: Scaffolding
doskey newfarm=bun create farm@latest $*
doskey newrefine=bun create refine-app@latest $*
doskey newrsbuild=bun create rsbuild@latest $*
doskey newstorybook=npx storybook@latest init $*
doskey newvite=bun create vite@latest $*

doskey nx=powershell -NoLogo -Command nx $*
doskey tf=terraform $*
doskey va=vagrant $*
doskey igradle=powershell -NoLogo -Command igradle
doskey npmig=powershell -NoLogo -Command npmig
doskey tsall=powershell -NoLogo -Command tsall

:: Installer shortcuts that run natively on Windows
doskey ibombardier=go install github.com/codesenberg/bombardier@latest $*
doskey idatree=go install github.com/datreeio/datree@latest $*
doskey igogg=go install github.com/habedi/gogg@latest $*
doskey igotop=go install github.com/xxxserxxx/gotop/v4@latest $*
doskey igotty=go install github.com/yudai/gotty@latest $*
doskey ihey=go install github.com/rakyll/hey@latest $*
doskey ik3sup=go install github.com/alexellis/k3sup@latest $*
doskey ik9s=go install github.com/derailed/k9s@latest $*
doskey ikind=go install sigs.k8s.io/kind@latest $*
doskey ikubectx=go install github.com/ahmetb/kubectx/cmd/kubectx@latest $*
doskey ikubens=go install github.com/ahmetb/kubectx/cmd/kubens@latest $*
doskey ilazygit=go install github.com/jesseduffield/lazygit@latest $*
doskey ilux=go install github.com/iawia002/lux@latest $*
doskey iscc=go install github.com/boyter/scc/v4@latest $*
doskey iserve=go install github.com/chneau/serve@latest $*
doskey istern=go install github.com/stern/stern@latest $*
doskey idl=uv tool install --force yt-dlp
doskey ibpytop=uv tool install --force bpytop
doskey icolab=uv tool install --force google-colab-cli
doskey ilivereload=uv tool install --force livereload
doskey ipaseo=bun install -g @getpaseo/cli@latest
doskey iknip=bun install --global knip@latest
doskey ideno=powershell -c "irm https://deno.land/install.ps1 | iex"

:: ==============================================================================
:: 8. AI Coding Assistants & CLI Tools
:: ==============================================================================
doskey cl=claude $*
doskey cly=claude --dangerously-skip-permissions $*
doskey iclaude=powershell -c "irm https://claude.ai/install.ps1 | iex"
doskey agyy=agy --dangerously-skip-permissions $*
doskey iagy=powershell -c "irm https://antigravity.google/cli/install.ps1 | iex"
doskey igravitycli=powershell -c "irm https://antigravity.google/cli/install.ps1 | iex"
doskey agenty=agent --yolo $*
doskey icursor=powershell -c "irm https://cursor.com/install.ps1 | iex"
doskey codexy=codex --dangerously-bypass-approvals-and-sandbox $*
doskey icodex=powershell -c "irm https://chatgpt.com/codex/install.ps1 | iex"
doskey icopilot=bun i -g @github/copilot@latest
doskey ocy=opencode --auto $*
doskey opencodey=opencode --auto $*
doskey iopencode=powershell -c "irm https://opencode.ai/install.ps1 | iex"
doskey kiloy=kilo --auto $*
doskey ikilo=powershell -c "irm https://kilo.ai/cli/install.ps1 | iex"
doskey hermesy=hermes --yolo $*
doskey ompy=omp --auto-approve $*
doskey ihermes=powershell -c "irm https://hermes-agent.nousresearch.com/install.ps1 | iex"
doskey reasonixy=reasonix --permission-mode bypassPermissions $*
doskey ry=reasonix --permission-mode bypassPermissions --yolo $*
doskey ryp=reasonix -p --permission-mode bypassPermissions --add-dir "%USERPROFILE%" --add-dir "%TEMP%" $*
doskey rw=reasonix web $*
doskey ireasonix=bun i -g reasonix@latest $*
doskey iqwen=bun install -fg @qwen-code/qwen-code@latest
doskey imcode=bun i -g @minimax-ai/code $*
doskey icf=bun i -g cf $*
doskey icharlie=bun i -g charlie-git@latest $*
doskey icline=bun i -g cline $*
doskey idsh=bun i -g @deepseek-ai/dsh@latest $*
doskey ijsdoc-scribe=bun i -g jsdoc-scribe@latest $*
doskey iposthogcli=bun i -g @posthog/cli@latest $*
doskey ifreebuff=bun i -g freebuff@latest $*
doskey icommandcode=bun i -g command-code@latest $*
doskey ideepcode=bun i -g @vegamo/deepcode-cli@latest $*
doskey iskillsmattpocock=bunx skills add mattpocock/skills $*
doskey iherdr=powershell -c "irm https://herdr.dev/install.ps1 | iex"
doskey ituios=powershell -c "irm https://raw.githubusercontent.com/Gaurav-Gosain/tuios/main/install.ps1 | iex"
doskey iccusage=bun i -g ccusage@latest $*
doskey reactdoctor=bunx react-doctor@latest $*
doskey ipi=powershell -c "irm https://pi.dev/install.ps1 | iex"
doskey iomp=bun install -g @oh-my-pi/pi-coding-agent $*
doskey irtk=powershell -c "irm https://raw.githubusercontent.com/rtk-ai/rtk/master/install.ps1 | iex"
doskey ibun=powershell -c "irm bun.sh/install.ps1 | iex"
doskey iuv=powershell -c "irm https://astral.sh/uv/install.ps1 | iex"
doskey ix=bun install --force --global @chneau/x
doskey imas=powershell -c "irm https://massgrave.dev/get | iex"
doskey idefendnot=powershell -c "irm https://dnot.sh/ | iex"

:: ==============================================================================
:: 9. Media & Utilities
:: ==============================================================================
doskey yt=yt-dlp $*
doskey dlfast=lux -n 100 -m $*
doskey ymp4=yt-dlp -S res,ext:mp4:m4a --recode mp4 $*
doskey ymp4s=yt-dlp -S res,ext:mp4:m4a --recode mp4 --embed-subs --sub-lang en --add-metadata --convert-subs srt --embed-thumbnail $*
doskey ymp3=yt-dlp --restrict-filenames --continue --ignore-errors --download-archive downloaded.txt --no-post-overwrites --no-overwrites --extract-audio --audio-format mp3 --output "%%(title)s.%%(ext)s" $*
doskey lg=lazygit $*
doskey rtk=rtk $*

:: ==============================================================================
:: 10. Network, Upload & Share
:: ==============================================================================
doskey myip=powershell -NoLogo -Command myip
doskey mip=powershell -NoLogo -Command mip
doskey mip2=powershell -NoLogo -Command mip2
doskey mh=powershell -NoLogo -Command mh
doskey weather=powershell -NoLogo -Command weather $*
doskey curlt=powershell -NoLogo -Command curlt $*
doskey h=powershell -NoLogo -Command h $*
doskey ports=netstat -ano $*
doskey openports=nmap -p- portquiz.net ^| findstr /i open
doskey portinuse=powershell -NoLogo -Command portinuse $*
doskey portkill=powershell -NoLogo -Command portkill $*
doskey serveo=powershell -NoLogo -Command serveo $*
doskey issh=ssh-keygen -t rsa -b 2048 $*
doskey sshgenkey=mkdir .ssh 2^>nul ^& ssh-keygen -t rsa -f .ssh/id_rsa -q -N ""
doskey sshkillagents=ssh-add -D
doskey traefikauth=powershell -NoLogo -Command traefikauth $*
doskey fio=powershell -NoLogo -Command fio $*
doskey fio1=powershell -NoLogo -Command fio1 $*
doskey pasteit=powershell -NoLogo -Command "$input | pasteit $*"
doskey tb=powershell -NoLogo -Command "$input | tb"
doskey topb=powershell -NoLogo -Command "$input | topb"
doskey toqrcode=powershell -NoLogo -Command "$input | toqrcode"
doskey wsldocker=wsl --user root service docker start ^& wsl

:: ==============================================================================
:: 11. Update Shortcuts
:: ==============================================================================
doskey updateprofile=powershell -c "updateprofile"
doskey updatebashrc=powershell -c "updateprofile"
doskey up=powershell -c "updateprofile"
doskey upb=powershell -c "updateprofile; refresh"
