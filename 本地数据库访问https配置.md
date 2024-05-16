
对于自治数据库或者http访问，开通开放网络访问权限ACL即可访问外部链接。

对于本地数据库访问https链接，需要配置证书。否则会报错：

```sql
ORA-29273: HTTP request failed
ORA-29024: Certificate validation failure
```

## 配置https访问

### 1.下载证书

以本项目为例，需要访问的api是`api.deepseek.com`，可以使用网站`https://www.deepseek.com/`的证书。

使用浏览器打开`https://www.deepseek.com/`，点击地址栏上的安全选项，即可查看网站证书信息。具体操作可以搜索"*chrome 获取ssl证书* "。

注意：证书是有层次结构的，要下载最顶层证书，而不是内层证书。

下载后将证书保存为 `.p7c` 文件，然后放到数据库所在主机的任意可访问位置。例如：`/home/oracle/DigiCert Global Root CA.p7c`。

### 2.创建wallet

1. 创建文件夹以存放wallet文件

```bash
mkdir -p /home/oracle/admin/mydb/my_wallet
```

2. 创建wallet，指定位置为上述文件夹，指定密码

```bash
orapki wallet create -wallet /home/oracle/admin/mydb/my_wallet -pwd mypwd_1234 -auto_login
```

3. 将证书导入钱包

```bash
orapki wallet add -wallet /home/oracle/admin/mydb/my_wallet -trusted_cert -cert "/home/oracle/DigiCert Global Root CA.p7c" -pwd mypwd_1234
```

如果想删除wallet重新创建，可以执行如下命令：

```bash
orapki wallet remove -wallet /home/oracle/admin/mydb/my_wallet -trusted_cert_all  -pwd mypwd_1234
```

4. 检查钱包状态

```bash
orapki wallet display -wallet /home/oracle/admin/mydb/my_wallet
```

输出类似下面：

```bash
Requested Certificates:
User Certificates:
Trusted Certificates:
Subject:        CN=DigiCert Global Root CA,OU=www.digicert.com,O=DigiCert Inc,C=US

```
  
### 3.测试https访问

在数据库开启新会话，以确保更改生效。
使用 `DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(host => 'www.deepseek.com'.....` 为网站打开访问权限。

通过以下命令发送https请求：

方式1：

```sql
EXEC UTL_HTTP.set_wallet('file:/home/oracle/admin/mydb/my_wallet', 'mypwd_1234');
select UTL_HTTP.REQUEST('https://www.deepseek.com') RESPONSE from dual;
```

方式2：

```sql
  select UTL_HTTP.REQUEST('https://www.deepseek.com',NULL,'file:/home/oracle/admin/mydb/my_wallet','mypwd_1234') RESPONSE from dual;
```

返回结果类似下面，证明已经正确访问了网站：

```html
<!DOCTYPE html><html lang="en" class="__className_aaf875"><head><meta charSet="utf-8"/>......
```

注意：如果用同样的方法访问 `https://api.deepseek.com`，返回的结果是空白。因为api的访问需要一定的数据规则，没有出现报错，就说明访问成功了。