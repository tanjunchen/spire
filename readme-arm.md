# spire 

```images
docker pull registry.baidubce.com/spire/wait-for-it:latest
docker pull registry.baidubce.com/spire/spire-agent:1.5.3
docker pull registry.baidubce.com/spire/spire-server:1.5.3
docker pull registry.baidubce.com/spire/k8s-workload-registrar:1.5.3
```

```
bash arm.sh 即可
```
构建上述 arm 镜像，arm 中内容可以优化下。

## 参考

```
# git clone git@github.com:spiffe/spire.git
# cd spire/
# git checkout v1.5.3
# V=1 make
# 如果本地已经安装 go , 且 make 自动安装 go 网络不通,可以修改 `.go-version` 的内容为你的 go 版本,然后再执行 V=1 make
# 查看输出,可以看到其执行的go命令
```
