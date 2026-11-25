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

:: ==============================================================================
:: 4. File System & Utilities
:: ==============================================================================




:: Load .env into the current cmd session

:: Archive extraction and 72h uploads are implemented in .profile.ps1

:: ==============================================================================
:: 5. Git Shortcuts
:: ==============================================================================
:: Delegate to the PowerShell implementation (.profile.ps1) so cmd gets the same
:: local-only tag pruning and worktree cleanup logic in one place.

:: GPG

:: ==============================================================================
:: 6. Docker & Kubernetes
:: ==============================================================================

:: Docker commands that need path/quoting logic live in .profile.ps1


:: ==============================================================================
:: 7. Language Tools & Runtimes (Bun, Node, Go, Python/uv, DotNet, Zig)
:: ==============================================================================






:: Scaffolding


:: Installer shortcuts that run natively on Windows

:: ==============================================================================
:: 8. AI Coding Assistants & CLI Tools
:: ==============================================================================

:: ==============================================================================
:: 9. Media & Utilities
:: ==============================================================================

:: ==============================================================================
:: 10. Network, Upload & Share
:: ==============================================================================

:: ==============================================================================
:: 11. Update Shortcuts
:: ==============================================================================


:: >>> generated aliases >>>
:: [aliases]
doskey ..=cd .. $*
doskey ...=cd ..\.. $*
doskey ....=cd ..\..\.. $*
doskey a=ansible $*
doskey agenty=agent --yolo $*
doskey agyy=agy --dangerously-skip-permissions $*
doskey ai-help=powershell -NoLogo -Command aihelp $*
doskey aihelp=powershell -c "aihelp" $*
doskey b=bun $*
doskey bbmd=bun build --metafile-md $*
doskey bbx=bun --bun x $*
doskey bcp=bun --cpu-prof-md $*
doskey bcphp=bun --cpu-prof-md --heap-prof-md $*
doskey bd=bun run dev $*
doskey bench=hyperfine $*
doskey bfmt=bun fmt --no-script ^& bun lint --fix --no-script $*
doskey bh=bun --hot --no-clear-screen $*
doskey bhp=bun --heap-prof-md $*
doskey bi=bun install --force --no-save $*
doskey bic=bun fmt --no-script ^& bun lint --fix --no-script $*
doskey bo=bun outdated $*
doskey br=bun run $*
doskey brp=bun run --parallel $*
doskey brs=bun run --sequential $*
doskey bs=bun start $*
doskey bverbosefetch=set "BUN_CONFIG_VERBOSE_FETCH=curl" ^& $* ^& set "BUN_CONFIG_VERBOSE_FETCH=" $*
doskey bw=bun --watch --no-clear-screen $*
doskey bx=bun x $*
doskey bxb=bun --bun x $*
doskey catfull=bat --style=full $*
doskey cc=concurrently --prefix-colors=auto $*
doskey cl=claude $*
doskey cli-help=powershell -NoLogo -Command clihelp $*
doskey clihelp=powershell -c "clihelp" $*
doskey cly=claude --dangerously-skip-permissions $*
doskey codexy=codex --dangerously-bypass-approvals-and-sandbox $*
doskey completeall=completeall $*
doskey cpuinfo=powershell -NoLogo -Command cpuinfo $*
doskey ct=powershell -NoLogo -Command "$input | ct" $*
doskey curlt=powershell -NoLogo -Command curlt $*
doskey d=docker $*
doskey db=docker build --pull --tag $*
doskey dbpush=docker build --pull --push --tag $*
doskey dbtest=docker build --pull --tag test . $*
doskey dc=docker compose $*
doskey dc9router=powershell -NoLogo -Command dc9router $*
doskey dc9routerup=powershell -NoLogo -Command dc9routerup $*
doskey dcb=powershell -NoLogo -Command dcb $*
doskey dcode=powershell -NoLogo -Command dcode $*
doskey dcps=powershell -NoLogo -Command dcps $*
doskey ddown=powershell -NoLogo -Command ddown $*
doskey de=docker exec -it $*
doskey df=powershell -NoLogo -Command df $*
doskey dff=powershell -NoLogo -Command dfirefox $*
doskey dfirefox=powershell -NoLogo -Command dfirefox $*
doskey di=docker images $*
doskey diff=git diff --no-index $*
doskey dir=dir --color=auto $*
doskey diskspace=powershell -NoLogo -Command diskspace $*
doskey djellyfin=powershell -NoLogo -Command djellyfin $*
doskey dk=powershell -NoLogo -Command dk $*
doskey dkill=powershell -NoLogo -Command dkill $*
doskey dkilla=powershell -NoLogo -Command dkilla $*
doskey dl=docker logs --tail 40 -f $*
doskey dlfast=lux -n 100 -m $*
doskey dlog=powershell -NoLogo -Command dlog $*
doskey dm=powershell -NoLogo -Command dm $*
doskey dn=powershell -NoLogo -Command dn $*
doskey dnd=docker run --rm -it --pull=always --name=netdata --pid=host --network=host -v netdataconfig:/etc/netdata -v netdatalib:/var/lib/netdata -v netdatacache:/var/cache/netdata -v /:/host/root:ro,rslave -v /etc/passwd:/host/etc/passwd:ro -v /etc/group:/host/etc/group:ro -v /etc/localtime:/etc/localtime:ro -v /proc:/host/proc:ro -v /sys:/host/sys:ro -v /etc/os-release:/host/etc/os-release:ro -v /var/log:/host/var/log:ro -v /var/run/docker.sock:/var/run/docker.sock:ro -v /run/dbus:/run/dbus:ro --cap-add SYS_PTRACE --cap-add SYS_ADMIN --security-opt apparmor=unconfined --no-healthcheck netdata/netdata $*
doskey dndd=docker run --detach --pull=always --name=netdata --pid=host --network=host -v netdataconfig:/etc/netdata -v netdatalib:/var/lib/netdata -v netdatacache:/var/cache/netdata -v /:/host/root:ro,rslave -v /etc/passwd:/host/etc/passwd:ro -v /etc/group:/host/etc/group:ro -v /etc/localtime:/etc/localtime:ro -v /proc:/host/proc:ro -v /sys:/host/sys:ro -v /etc/os-release:/host/etc/os-release:ro -v /var/log:/host/var/log:ro -v /var/run/docker.sock:/var/run/docker.sock:ro -v /run/dbus:/run/dbus:ro --restart always --cap-add SYS_PTRACE --cap-add SYS_ADMIN --security-opt apparmor=unconfined --no-healthcheck netdata/netdata $*
doskey dnekoff=docker run --pull=always --rm -it --name=neko --shm-size=2gb --net=host --env=NEKO_DESKTOP_SCREEN=1920x1080@30 --env=NEKO_MEMBER_MULTIUSER_USER_PASSWORD=c --env=NEKO_MEMBER_MULTIUSER_ADMIN_PASSWORD=cc --env=NEKO_WEBRTC_EPR=52000-52100 --env=NEKO_WEBRTC_ICELITE=1 ghcr.io/m1k1o/neko/firefox $*
doskey dockertags=powershell -NoLogo -Command dockertags $*
doskey dockerup=docker run --pull=always --rm -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower --cleanup --remove-volumes --debug --run-once $*
doskey doh=docker history $*
doskey dotnetfmt=dotnet csharpier . $*
doskey dotnethttps=dotnet dev-certs https --clean ^& dotnet dev-certs https --trust $*
doskey dotneti=powershell -NoLogo -Command dotneti $*
doskey dotnetig=powershell -NoLogo -Command dotnetig $*
doskey dotnetup=dotnet outdated --upgrade $*
doskey dpihole=powershell -NoLogo -Command dpihole $*
doskey dprune=docker system prune --force --volumes ^& docker volume prune --force $*
doskey dprunea=docker system prune --force --volumes --all ^& docker volume prune --force --all $*
doskey dps=docker ps $*
doskey drm=powershell -NoLogo -Command drm $*
doskey ds=docker stats $*
doskey dsave=powershell -NoLogo -Command dsave $*
doskey dsd=docker stack down $*
doskey dsdf=docker system df $*
doskey dsi=docker service inspect --pretty $*
doskey dsl=docker service logs -f $*
doskey dsls=docker service ls --tail 40 $*
doskey dsu=docker stack up -c $*
doskey dt=docker run --rm -it $*
doskey dtest=docker run --rm -it --name test --hostname test $*
doskey dtf=powershell -NoLogo -Command dtf $*
doskey du=powershell -NoLogo -Command du $*
doskey dup=powershell -NoLogo -Command dockerup $*
doskey dwatch=docker run --pull=always -d --restart=always --name=watchtower -v=/var/run/docker.sock:/var/run/docker.sock:ro containrrr/watchtower --cleanup --remove-volumes $*
doskey e=powershell -NoLogo -Command e $*
doskey ee=for /f "usebackq eol=# tokens=1,* delims==" %a in (.env) do set "%a=%b" $*
doskey egrep=findstr /i /r $*
doskey exportenv=for /f "usebackq eol=# tokens=1,* delims==" %a in (.env) do set "%a=%b" $*
doskey extract=powershell -NoLogo -Command extract $*
doskey ff=powershell -NoLogo -Command ff $*
doskey fgrep=findstr /i /c:$* $*
doskey findfile=dir /s /b $*
doskey findtext=findstr /s /i /n /c:"$*" .\* $*
doskey fio=powershell -NoLogo -Command fio $*
doskey fio1=powershell -NoLogo -Command fio1 $*
doskey firewall=iptlist $*
doskey fixgitbashbatfiles=fixgitbashbatfiles $*
doskey fixionotify=fixinotify $*
doskey fixionotifyinstances=fixinotifyinstances $*
doskey fixionotifywatches=fixinotifywatches $*
doskey fixtz=timedatectl set-timezone Europe/London $*
doskey fixvpnipv4=nmcli connection modify VPN_NAME ipv6.method disabled $*
doskey fk=fkill --force $*
doskey free=powershell -NoLogo -Command free $*
doskey ga=git add $*
doskey gb=git branch --sort=-committerdate -vv $*
doskey gba=git branch --sort=-committerdate -vva $*
doskey gc=git commit -v $*
doskey gca=git commit . -v $*
doskey gcam=git commit -a -m $*
doskey gcamp=git commit -a -m $* $T git push $*
doskey gcl=git clone $*
doskey gco=git checkout $*
doskey gcom=git checkout master $*
doskey gd=git diff $*
doskey genpwd=powershell -NoLogo -Command genpwd $*
doskey genuuid=powershell -NoLogo -Command genuuid $*
doskey gg=powershell -NoLogo -Command gg $*
doskey gigit=git clone --depth=1 $*
doskey gitclean=powershell -NoLogo -Command gitclean $*
doskey gitcleanf=powershell -NoLogo -Command gitcleanf $*
doskey gitcleanr=powershell -NoLogo -Command gitcleanr $*
doskey gitget=powershell -NoLogo -Command gitget $*
doskey gitgetc=powershell -NoLogo -Command gitgetc $*
doskey gitmessage=powershell -NoLogo -Command gitmessage $*
doskey gitnewfresh=git checkout --orphan $*
doskey gitrmtag=git push -d origin $*
doskey gl=git pull $*
doskey gla=git pull --all $*
doskey glog=git log --graph --pretty=format:"%%Cred%%h%%Creset %%an: %%s - %%C(yellow)%%d%%Creset %%Cgreen(%%cr)%%Creset" --abbrev-commit --date=relative $*
doskey glom=git pull origin master $*
doskey gobuild=powershell -NoLogo -Command gobuild $*
doskey gocd=powershell -NoLogo -Command gocd $*
doskey goget=powershell -NoLogo -Command goget $*
doskey goi=go install $*
doskey goinst=powershell -NoLogo -Command goinst $*
doskey gols=powershell -NoLogo -Command gols $*
doskey gotest=go test -cover -count=1 $*
doskey gotestfast=go test -v ./... $*
doskey gotidy=go mod tidy ^& go mod verify $*
doskey goup=powershell -NoLogo -Command goup $*
doskey gp=git push $*
doskey gpcb=powershell -NoLogo -Command gpcb $*
doskey gpgexport=gpg --armor --export $*
doskey gpggit=git config --global user.signingkey $*
doskey gpglist=gpg --list-secret-keys --keyid-format LONG $*
doskey gpgnew=gpg --default-new-key-algo rsa4096 --gen-key $*
doskey gpm=powershell -NoLogo -Command gpm $*
doskey gr=powershell -NoLogo -Command gr $*
doskey grb=powershell -NoLogo -Command grb $*
doskey grba=git rebase --abort $*
doskey grbc=git rebase --continue $*
doskey grep=findstr /i $*
doskey grephere=findstr /s /i /n /w /c:$* .\* $*
doskey grm=powershell -NoLogo -Command grm $*
doskey gs=git status -sb $*
doskey gsc=git switch -c $*
doskey gsp=git add -A $T git commit -m $* $T git push $*
doskey gsta=git stash push $*
doskey gstd=git stash drop $*
doskey gstl=git stash list $*
doskey gstp=git stash pop $*
doskey gsw=git switch $*
doskey gundopush=git push -f origin HEAD^:master $*
doskey h=powershell -NoLogo -Command h $*
doskey hermesy=hermes --yolo $*
doskey hf=hyperfine $*
doskey hla=helm list --all-namespaces $*
doskey hs=doskey /history ^| findstr $*
doskey iagy=powershell -c "irm https://antigravity.google/cli/install.ps1 | iex" $*
doskey ibombardier=go install github.com/codesenberg/bombardier@latest $*
doskey ibpytop=uv tool install --force bpytop $*
doskey ibun=powershell -c "irm bun.sh/install.ps1 | iex" $*
doskey iccusage=bun i -g ccusage@latest $*
doskey icf=bun i -g cf $*
doskey icharlie=bun i -g charlie-git@latest $*
doskey iclaude=powershell -c "irm https://claude.ai/install.ps1 | iex" $*
doskey icline=bun i -g cline $*
doskey icodex=powershell -c "irm https://chatgpt.com/codex/install.ps1 | iex" $*
doskey icolab=uv tool install --force google-colab-cli $*
doskey icommandcode=bun i -g command-code@latest $*
doskey icopilot=bun i -g @github/copilot@latest $*
doskey icursor=powershell -c "irm https://cursor.com/install.ps1 | iex" $*
doskey idatree=go install github.com/datreeio/datree@latest $*
doskey ideepcode=bun i -g @vegamo/deepcode-cli@latest $*
doskey idefendnot=powershell -c "irm https://dnot.sh/ | iex" $*
doskey idl=uv tool install --force yt-dlp $*
doskey idoctl=brew install doctl $*
doskey idsh=bun i -g @deepseek-ai/dsh@latest $*
doskey ifail2ban=ifail2ban $*
doskey ifreebuff=bun i -g freebuff@latest $*
doskey igem=brew install ruby $*
doskey igit=powershell -NoLogo -Command igit $*
doskey igogg=go install github.com/habedi/gogg@latest $*
doskey igotop=go install github.com/xxxserxxx/gotop/v4@latest $*
doskey igotty=go install github.com/yudai/gotty@latest $*
doskey igradle=powershell -NoLogo -Command igradle $*
doskey igravitycli=powershell -c "irm https://antigravity.google/cli/install.ps1 | iex" $*
doskey iherdr=powershell -c "irm https://herdr.dev/install.ps1 | iex" $*
doskey ihermes=powershell -c "irm https://hermes-agent.nousresearch.com/install.ps1 | iex" $*
doskey ihey=go install github.com/rakyll/hey@latest $*
doskey ijsdoc-scribe=bun i -g jsdoc-scribe@latest $*
doskey ik3sup=go install github.com/alexellis/k3sup@latest $*
doskey ik9s=go install github.com/derailed/k9s@latest $*
doskey ikamal=gem install kamal $*
doskey ikilo=powershell -c "irm https://kilo.ai/cli/install.ps1 | iex" $*
doskey ikind=go install sigs.k8s.io/kind@latest $*
doskey iknip=bun install --global knip@latest $*
doskey ikubectx=go install github.com/ahmetb/kubectx/cmd/kubectx@latest $*
doskey ikubens=go install github.com/ahmetb/kubectx/cmd/kubens@latest $*
doskey ilazygit=go install github.com/jesseduffield/lazygit@latest $*
doskey ilivereload=uv tool install --force livereload $*
doskey ilux=go install github.com/iawia002/lux@latest $*
doskey imas=powershell -c "irm https://massgrave.dev/get | iex" $*
doskey imcode=bun i -g @minimax-ai/code $*
doskey iomp=bun install -g @oh-my-pi/pi-coding-agent $*
doskey iopencode=powershell -c "irm https://opencode.ai/install.ps1 | iex" $*
doskey ipandoc=brew install pandoc $*
doskey ipaseo=bun install -g @getpaseo/cli@latest $*
doskey ipi=powershell -c "irm https://pi.dev/install.ps1 | iex" $*
doskey ipipx=brew install pipx $*
doskey iposthogcli=bun i -g @posthog/cli@latest $*
doskey iproxy=powershell -NoLogo -Command iproxy $*
doskey iqwen=bun install -fg @qwen-code/qwen-code@latest $*
doskey ireasonix=bun i -g reasonix@latest $*
doskey irtk=powershell -c "irm https://raw.githubusercontent.com/rtk-ai/rtk/master/install.ps1 | iex" $*
doskey iscc=go install github.com/boyter/scc/v4@latest $*
doskey iserve=go install github.com/chneau/serve@latest $*
doskey iskillsmattpocock=bunx skills add mattpocock/skills $*
doskey issh=ssh-keygen -t rsa -b 2048 $*
doskey istern=go install github.com/stern/stern@latest $*
doskey ituios=powershell -c "irm https://raw.githubusercontent.com/Gaurav-Gosain/tuios/main/install.ps1 | iex" $*
doskey iuv=powershell -c "irm https://astral.sh/uv/install.ps1 | iex" $*
doskey ivpn=ivpnnyr $*
doskey ix=bun install --force --global @chneau/x $*
doskey k=kubectl $*
doskey ka=kubectl apply -f $*
doskey kak=kubectl apply -k $*
doskey kar=kubectl api-resources $*
doskey kclean=powershell -NoLogo -Command kclean $*
doskey kconf=kubectl config view --raw $*
doskey kcron=echo kubectl create job --from=cronjob/dump manual-001 $*
doskey kctx=kubectx $*
doskey kd=kubectl diff -f $*
doskey kdebug=kubectl run -i --tty --rm debug --image=alpine --restart=Never -- sh $*
doskey kdecode=powershell -NoLogo -Command kdecode $*
doskey kdes=kubectl describe $*
doskey kdestroy=kubectl delete --grace-period=0 --force $*
doskey kdk=kubectl diff -k $*
doskey kdn=kubectl describe node $*
doskey ke=kubectl exec -ti $*
doskey kenv=kubectl set env pods --all --list $*
doskey kex=kubectl explain $*
doskey kg=kubectl get $*
doskey kga=kubectl get all,ingress $*
doskey kgaa=kubectl get all,ingress --all-namespaces $*
doskey kgapi=kubectl get apiservices $*
doskey kgd=kubectl get deployment,statefulset,daemonset,cronjob $*
doskey kge=kubectl get events $*
doskey kgea=kubectl get events --all-namespaces $*
doskey kgia=kubectl get ingress --all-namespaces $*
doskey kgpa=kubectl get pods --all-namespaces $*
doskey kgs=kubectl get secret $*
doskey kiloy=kilo --auto $*
doskey kk=kubectl kustomize $*
doskey kkill=kubectl delete pods --grace-period=0 --force --all $*
doskey kl=kubectl logs -f --tail=40 $*
doskey klall=kubectl stern --max-log-requests=999 --since=1s $*
doskey klall_old=kubectl logs --selector=pod-template-hash --all-containers --ignore-errors --follow --max-log-requests=999 --timestamps --prefix $*
doskey klallall=kubectl stern --all-namespaces --max-log-requests=999 --since=1s $*
doskey kll=kubectl logs -f --tail=40 --timestamps --prefix $*
doskey kmip=kubectl run debug --stdin --tty --rm --image=alpine --restart=Never -- sh -ci "wget -qO- api.ipify.org && echo" $*
doskey kns=kubens $*
doskey knt=kubent $*
doskey kpf=kubectl port-forward $*
doskey kr=kubectl rollout $*
doskey krewig=kubectl krew install ns ctx stern ^& kubectl krew upgrade $*
doskey krr=kubectl rollout restart $*
doskey ks0=kubectl scale --replicas=0 deployment --all ^& kubectl scale --replicas=0 statefulset --all $*
doskey ks1=kubectl scale --replicas=1 deployment --all ^& kubectl scale --replicas=1 statefulset --all $*
doskey ktest=powershell -NoLogo -Command ktest $*
doskey ktn=kubectl top nodes $*
doskey ktp=kubectl top pods --sort-by=memory $*
doskey ktpa=kubectl top pods --all-namespaces --sort-by=memory $*
doskey kw=kubectl get po -w $*
doskey l=dir /w $*
doskey la=dir /a /o:gn $*
doskey lg=lazygit $*
doskey lh=dir /a /o:gn $*
doskey ll=dir /a /o:gn $*
doskey lld=powershell -NoLogo -Command lld $*
doskey lo=powershell -NoLogo -Command lo $*
doskey ls=dir /o:gn $*
doskey m=make $*
doskey mapscii=telnet mapscii.me $*
doskey meminfo=powershell -NoLogo -Command meminfo $*
doskey mh=powershell -NoLogo -Command mh $*
doskey mip=powershell -NoLogo -Command mip $*
doskey mip2=powershell -NoLogo -Command mip2 $*
doskey mkcdir=powershell -NoLogo -Command mkcdir $*
doskey mkdir=mkdir -pv $*
doskey myip=powershell -NoLogo -Command myip $*
doskey ncup=npm-check-updates --upgrade --install=always --packageManager=bun --deep $*
doskey newfarm=bun create farm@latest $*
doskey newrefine=bun create refine-app@latest $*
doskey newrsbuild=bun create rsbuild@latest $*
doskey newstorybook=npx storybook@latest init $*
doskey newvite=bun create vite@latest $*
doskey nload=nload -m -u M $*
doskey now=time /t $*
doskey nowdate=date /t $*
doskey nowtime=time /t $*
doskey npme=npm exec --yes -- $*
doskey npmig=powershell -NoLogo -Command npmig $*
doskey npmup=npm-check-updates --deep --upgrade --install=always --packageManager=bun $*
doskey nud=nvm use default $*
doskey nx=powershell -NoLogo -Command nx $*
doskey oc=code -a . $*
doskey ocy=opencode --auto $*
doskey ompu=omp update $*
doskey ompy=omp --auto-approve $*
doskey opencodey=opencode --auto $*
doskey openports=nmap -p- portquiz.net ^| findstr /i open $*
doskey pasteit=powershell -NoLogo -Command "$input | pasteit $*" $*
doskey path=powershell -NoLogo -Command path $*
doskey pipi=uv pip install --upgrade $*
doskey pipig=uv tool install $*
doskey pipup=uv pip install --upgrade $*
doskey pipupg=uv tool upgrade --all $*
doskey poefilterup=poefilterup $*
doskey portinuse=powershell -NoLogo -Command portinuse $*
doskey portkill=powershell -NoLogo -Command portkill $*
doskey ports=netstat -ano $*
doskey ps=tasklist $*
doskey pscpu=powershell -NoLogo -Command pscpu $*
doskey pscpu10=powershell -NoLogo -Command pscpu10 $*
doskey psg=powershell -NoLogo -Command psg $*
doskey psmem=powershell -NoLogo -Command psmem $*
doskey psmem10=powershell -NoLogo -Command psmem10 $*
doskey pstats=powerstat -d 0 -f 1 $*
doskey reactdoctor=bunx react-doctor@latest $*
doskey reasonixy=reasonix --permission-mode bypassPermissions $*
doskey refresh=call "%USERPROFILE%\.profile.cmd" $*
doskey refreshgroups=exec sudo su -l $USER $*
doskey root=\sudo \su $*
doskey rtk=rtk $*
doskey rw=reasonix web $*
doskey ry=reasonix --permission-mode bypassPermissions --yolo $*
doskey ryp=reasonix -p --permission-mode bypassPermissions --add-dir "%USERPROFILE%" --add-dir "%TEMP%" $*
doskey s=strace -fqc $*
doskey screen=screen -q $*
doskey serveo=powershell -NoLogo -Command serveo $*
doskey servepy=uv run python -m http.server $*
doskey sshgenkey=mkdir .ssh 2^>nul ^& ssh-keygen -t rsa -f .ssh/id_rsa -q -N "" $*
doskey sshkillagents=ssh-add -D $*
doskey stripcolors=powershell -NoLogo -Command "$input | stripcolors" $*
doskey t=tmux $*
doskey ta=tmux a $*
doskey tb=powershell -NoLogo -Command "$input | tb" $*
doskey tf=terraform $*
doskey tmux-help=powershell -NoLogo -Command tmuxhelp $*
doskey tmuxhelp=powershell -NoLogo -Command tmuxhelp $*
doskey tobase64=powershell -NoLogo -Command tobase64 $*
doskey topb=powershell -NoLogo -Command "$input | topb" $*
doskey toqrcode=powershell -NoLogo -Command "$input | toqrcode" $*
doskey traefikauth=powershell -NoLogo -Command traefikauth $*
doskey transfer=powershell -NoLogo -Command "$input | transfer $*" $*
doskey tsall=powershell -NoLogo -Command tsall $*
doskey tsfmt=bun fmt --no-script ^& bun lint --fix --no-script $*
doskey tslint=tsc --noEmit --project . $*
doskey u=powershell -NoLogo -Command u $*
doskey up=powershell -c "updateprofile" $*
doskey upb=powershell -c "updateprofile; refresh" $*
doskey updatebashrc=powershell -c "updateprofile" $*
doskey updateprofile=powershell -c "updateprofile" $*
doskey upload-help=powershell -NoLogo -Command uploadhelp $*
doskey uploadhelp=powershell -NoLogo -Command uploadhelp $*
doskey va=vagrant $*
doskey vdir=vdir --color=auto $*
doskey weather=powershell -NoLogo -Command weather $*
doskey webshare=uv run python -m http.server $*
doskey wsldocker=wsl --user root service docker start ^& wsl $*
doskey ymp3=yt-dlp --restrict-filenames --continue --ignore-errors --download-archive downloaded.txt --no-post-overwrites --no-overwrites --extract-audio --audio-format mp3 --output "%%(title)s.%%(ext)s" $*
doskey ymp4=yt-dlp -S res,ext:mp4:m4a --recode mp4 $*
doskey ymp4s=yt-dlp -S res,ext:mp4:m4a --recode mp4 --embed-subs --sub-lang en --add-metadata --convert-subs srt --embed-thumbnail $*
doskey yt=yt-dlp $*
doskey z=zig $*
doskey zb=zig build $*
doskey zbr=zig build run $*
doskey ziup=zi update --all --parallel $*
doskey zr=zig run $*
:: <<< generated aliases <<<
