#!/usr/bin/env bash

# 设置各变量
WSPATH=${WSPATH:-'argo'}
UUID=${UUID:-'de04add9-5c68-8bab-950c-08cd5320df18'}

generate_config() {
  cat > config.json << EOF
{
    "log":{
        "access":"/dev/null",
        "error":"/dev/null",
        "loglevel":"none"
    },
    "inbounds":[
        {
            "port":8081,
            "protocol":"vless",
            "settings":{
                "clients":[
                    {
                        "id":"${UUID}",
                        "flow":"xtls-rprx-vision"
                    }
                ],
                "decryption":"none",
                "fallbacks":[
                    {
                        "dest":3001
                    },
                    {
                        "path":"/${WSPATH}-vless",
                        "dest":3002
                    },
                    {
                        "path":"/${WSPATH}-vmess",
                        "dest":3003
                    },
                    {
                        "path":"/${WSPATH}-trojan",
                        "dest":3004
                    },
                    {
                        "path":"/${WSPATH}-shadowsocks",
                        "dest":3005
                    }
                ]
            },
            "streamSettings":{
                "network":"tcp"
            }
        },
        {
            "port":3001,
            "listen":"127.0.0.1",
            "protocol":"vless",
            "settings":{
                "clients":[
                    {
                        "id":"${UUID}"
                    }
                ],
                "decryption":"none"
            },
            "streamSettings":{
                "network":"ws",
                "security":"none"
            }
        },
        {
            "port":3002,
            "listen":"127.0.0.1",
            "protocol":"vless",
            "settings":{
                "clients":[
                    {
                        "id":"${UUID}",
                        "level":0
                    }
                ],
                "decryption":"none"
            },
            "streamSettings":{
                "network":"ws",
                "security":"none",
                "wsSettings":{
                    "path":"/${WSPATH}-vless"
                }
            },
            "sniffing":{
                "enabled":true,
                "destOverride":[
                    "http",
                    "tls"
                ],
                "metadataOnly":false
            }
        },
        {
            "port":3003,
            "listen":"127.0.0.1",
            "protocol":"vmess",
            "settings":{
                "clients":[
                    {
                        "id":"${UUID}",
                        "alterId":0
                    }
                ]
            },
            "streamSettings":{
                "network":"ws",
                "wsSettings":{
                    "path":"/${WSPATH}-vmess"
                }
            },
            "sniffing":{
                "enabled":true,
                "destOverride":[
                    "http",
                    "tls"
                ],
                "metadataOnly":false
            }
        },
        {
            "port":3004,
            "listen":"127.0.0.1",
            "protocol":"trojan",
            "settings":{
                "clients":[
                    {
                        "password":"${UUID}"
                    }
                ]
            },
            "streamSettings":{
                "network":"ws",
                "security":"none",
                "wsSettings":{
                    "path":"/${WSPATH}-trojan"
                }
            },
            "sniffing":{
                "enabled":true,
                "destOverride":[
                    "http",
                    "tls"
                ],
                "metadataOnly":false
            }
        },
        {
            "port":3005,
            "listen":"127.0.0.1",
            "protocol":"shadowsocks",
            "settings":{
                "clients":[
                    {
                        "method":"chacha20-ietf-poly1305",
                        "password":"${UUID}"
                    }
                ],
                "decryption":"none"
            },
            "streamSettings":{
                "network":"ws",
                "wsSettings":{
                    "path":"/${WSPATH}-shadowsocks"
                }
            },
            "sniffing":{
                "enabled":true,
                "destOverride":[
                    "http",
                    "tls"
                ],
                "metadataOnly":false
            }
        }
    ],
    "dns":{
        "servers":[
            "https+local://8.8.8.8/dns-query"
        ]
    },
    "outbounds":[
        {
            "protocol":"freedom"
        },
        {
            "tag":"WARP",
            "protocol":"wireguard",
            "settings":{
                "secretKey":"cKE7LmCF61IhqqABGhvJ44jWXp8fKymcMAEVAzbDF2k=",
                "address":[
                    "172.16.0.2/32",
                    "fd01:5ca1:ab1e:823e:e094:eb1c:ff87:1fab/128"
                ],
                "peers":[
                    {
                        "publicKey":"bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=",
                        "endpoint":"162.159.193.10:2408"
                    }
                ]
            }
        }
    ],
    "routing":{
        "domainStrategy":"AsIs",
        "rules":[
            {
                "type":"field",
                "domain":[
                    "domain:openai.com",
                    "domain:ai.com"
                ],
                "outboundTag":"WARP"
            }
        ]
    }
}
EOF
}
generate_config_yml() {
    # rm -rf /app/apps/config.yml
  cat > /app/apps/config.yml << EOF
Log:
  Level: none # Log level: none, error, warning, info, debug 
  AccessPath: # /etc/XrayR/access.Log
  ErrorPath: # /etc/XrayR/error.log
DnsConfigPath: # /etc/XrayR/dns.json # Path to dns config, check https://xtls.github.io/config/dns.html for help
RouteConfigPath: # /etc/XrayR/route.json # Path to route config, check https://xtls.github.io/config/routing.html for help
InboundConfigPath: # /etc/XrayR/custom_inbound.json # Path to custom inbound config, check https://xtls.github.io/config/inbound.html for help
OutboundConfigPath: # /etc/XrayR/custom_outbound.json # Path to custom outbound config, check https://xtls.github.io/config/outbound.html for help
ConnectionConfig:
  Handshake: 4 # Handshake time limit, Second
  ConnIdle: 30 # Connection idle time limit, Second
  UplinkOnly: 2 # Time limit when the connection downstream is closed, Second
  DownlinkOnly: 4 # Time limit when the connection is closed after the uplink is closed, Second
  BufferSize: 64 # The internal cache size of each connection, kB
Nodes:
  -
    PanelType: "NewV2board" # Panel type: SSpanel, V2board, NewV2board, PMpanel, Proxypanel, V2RaySocks
    ApiConfig:
      ApiHost: "${API_HOST}"
      ApiKey: "${API_KEY}"
      NodeID: ${NODE_ID}
      NodeType: V2ray # Node type: V2ray, Shadowsocks, Trojan
      Timeout: 60 # Timeout for the api request
      EnableVless: false # Enable Vless for V2ray Type
      EnableXTLS: false # Enable XTLS for V2ray and Trojan
      SpeedLimit: 0 # Mbps, Local settings will replace remote settings
      DeviceLimit: 0 # Local settings will replace remote settings
    ControllerConfig:
      ListenIP: 127.0.0.1 # IP address you want to listen
      UpdatePeriodic: 10 # Time to update the nodeinfo, how many sec.
      EnableDNS: false # Use custom DNS config, Please ensure that you set the dns.json well
      CertConfig:
        CertMode: file # Option about how to get certificate: none, file, http, tls, dns. Choose "none" will forcedly disable the tls config.
        CertDomain: "${CERT_DOMAIN}" # Domain to cert
        CertFile: /app/ca.pem # Provided if the CertMode is file
        KeyFile: /app/ca.key
EOF
}
generate_ca() {
    rm -rf /app/ca.pem
    rm -rf /app/ca.pem
    cat > /app/ca.key << EOF
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAoGXGNMOZc+DONcimqNM2mU2Xt+cjSWeHRB0V3c2z9ks38ka7
yXQXUIp8L/4t0YcNNdlAT4KeK1zxaN1NqAfmdkFsZPI5kfd7dGa6+8JG7S3eCc32
cIxtcysQBF41WyASrglTp64xyLzqMLIMACRjaLm5v+s7+c/2Jn91ohjbeLv7L7fk
Eh2/xNmYQJm3eeqHN2tgZjP6RiAXjezCe4JD8LDzc8nGMfSvxwuWNNGTr0G27GfP
WZ4nJeK+FDO1vhkIKX+ENgRu9apnMZO8m37C+VprR1kfc7KGCfjzyTPHZ1/Z04aJ
peVK2e9xv5tqKmL0VspTEIDQcxVCyAkXr0hqowIDAQABAoIBABZyp+6ygUNqbvGw
B0MRbE7AQT+HpbScPJ4Xw/uq0kjh9g5+P8HN8YVgHElLNXZhhEPJB+sYyLIg69hV
QI0HrgVW2qi2DcCT9j8wMXMSmYKQLMcKgDb4MEkx+afi12zNbE/XFlIdWvJRHiV6
hZtvfEon1As8DMTFihmRNRFekTiwPLgWx8X9zaQq9/Rocn6qEjrLCC1Z4PbkRwu9
CcZeOUJuX8xiHb1NeFdfaADjZi4/cKu+4WNbjZcz0TlTx5UFDOHUz8GQH5Zdng8y
4bFAgmyn5maC9HZ+KytsFv4Vm/XJsML8JuNW6jVTF6mj+77r3XekrTD/bBbpH+SK
fiykYeECgYEA8cafnqxsBOKfaK9C6Yh3Ua45F5t3tUTEcGF2w7ttXM5Ufbmct4li
q36i3PvyQoKFG1pPFzF7AmnTfVGtU7bbR4ikbzCrMj7CSCr3tD37pgKUjp8rCxPt
bwHAHNS7HayGmVHITYOsguQ9WlGE0su7VEcunYiVoqp7vCReDhp/78UCgYEAqdWD
5l3VzSNpEqtXSBtNAHsYE6N9ryhJgzlMMq5xIZ4Stmdk7oVsroRB44btoi6ze6nH
E2tSHoRr59vzqDrqMIboNjl9YLTAecUMUmGxdFlKL8O34IfjaShlbg948N0wX/i6
8eeO7VqV7f1Wabzkrwj2HhhB5V+COcgb8gxk70cCgYEAuudIJ9q02oXyo3OxL2WO
j/c2LXjC7r+NeC7wJ9mxbmgWyuZ9LykmvNp1vo2KNz489es3bv+ST0hN9Pf6HNgj
5cXNECO4hGwdtrp4qL6t1iTygNqs5LBwATuCLweI6ySfHNErHjknWDxm7XZNTsOu
OjWY5LFcs9ZFNymKCC8WLd0CgYBQnSzSuE+348sINZRkgbD3PXacO8p4zeK3CweE
NxE0J9gyBLoADg0ceWLdITrC9O/1Dw2TxilgmvKtR9ZMUErBZgfrVTaSJLoIEuRa
ZkzZMVjpezlYtqfXTnl22JlLm3JO273A/Wz2dT0djlbqMeNKwjIw7sq4mbEyxC2f
owp2GQKBgQDi8/BC7GA3DWnBMqYdNBC7qZO0VSSosk8yYkcmzWdpwGhlsGBAdIoT
j3gFKdJxEtMC95Xw2hOFEkmntJJeSUSX39/aUmunSldzpOVhhKHYCfHXIFHa6f8j
HpTTb+23vPb2rj8+goBg9Rt18mBRSp9bk8wlxAGIwqHFUrics+i4pA==
-----END RSA PRIVATE KEY-----
EOF
cat > /app/ca.pem << EOF
-----BEGIN CERTIFICATE-----
MIIDiTCCAnGgAwIBAgIELyBnuTANBgkqhkiG9w0BAQsFADBbMScwJQYDVQQDDB5SZWdlcnkgU2Vs
Zi1TaWduZWQgQ2VydGlmaWNhdGUxIzAhBgNVBAoMGlJlZ2VyeSwgaHR0cHM6Ly9yZWdlcnkuY29t
MQswCQYDVQQGEwJVQTAgFw0yMzAzMjgwMDAwMDBaGA8yMTIzMDMyODEwMjkxOVowSzEXMBUGA1UE
AwwOd3d3LnJlbmRlci5jb20xIzAhBgNVBAoMGlJlZ2VyeSwgaHR0cHM6Ly9yZWdlcnkuY29tMQsw
CQYDVQQGEwJVQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKBlxjTDmXPgzjXIpqjT
NplNl7fnI0lnh0QdFd3Ns/ZLN/JGu8l0F1CKfC/+LdGHDTXZQE+Cnitc8WjdTagH5nZBbGTyOZH3
e3RmuvvCRu0t3gnN9nCMbXMrEAReNVsgEq4JU6euMci86jCyDAAkY2i5ub/rO/nP9iZ/daIY23i7
+y+35BIdv8TZmECZt3nqhzdrYGYz+kYgF43swnuCQ/Cw83PJxjH0r8cLljTRk69Btuxnz1meJyXi
vhQztb4ZCCl/hDYEbvWqZzGTvJt+wvlaa0dZH3Oyhgn488kzx2df2dOGiaXlStnvcb+baipi9FbK
UxCA0HMVQsgJF69IaqMCAwEAAaNjMGEwDwYDVR0TAQH/BAUwAwEB/zAOBgNVHQ8BAf8EBAMCAYYw
HQYDVR0OBBYEFHx6uTS/jOqVr7PCuBNhIiCNY0gQMB8GA1UdIwQYMBaAFHx6uTS/jOqVr7PCuBNh
IiCNY0gQMA0GCSqGSIb3DQEBCwUAA4IBAQB1B4JpJmybk8cfHZr/rng6SGs+pUUUxTEUalVTq9j2
L39v4d3M/KCNaMLtO4UTWIZ2nqprB0NP2/3ZCiy4fUx9T0xButQjj0YFe00pDgegEDp+NiJ38MBi
MyFkbXEqJd6ctBM/Qd3jus6DaEsEOvNU/coxViLopntenOdCUfPF31eH5B+myV8XmZxg3tKw2FU9
1EIiTl3gYrnFvY0kMQcp9MWYv/Njl7MSPGvunllNRjeMt/iVq+4X2t3p1ANAURQqKmL/fy79JSDS
TYehJJQC3B5VipbnQNtykE6TQJZrKv2vBVzcFfli9W8gBpD6JN0kc3OMf3txev6BNv3s7S1r
-----END CERTIFICATE-----
EOF
}

generate_argo() {
  cat > argo.sh << ABC
#!/usr/bin/env bash

argo_type() {
  if [[ -n "\${ARGO_AUTH}" && -n "\${ARGO_DOMAIN}" ]]; then
    [[ \$ARGO_AUTH =~ TunnelSecret ]] && echo \$ARGO_AUTH > tunnel.json && echo -e "tunnel: \$(cut -d\" -f12 <<< \$ARGO_AUTH)\ncredentials-file: /app/tunnel.json" > tunnel.yml
  else
    ARGO_DOMAIN=\$(cat argo.log | grep -o "info.*https://.*trycloudflare.com" | sed "s@.*https://@@g" | tail -n 1)
  fi
}

export_list() {
  VMESS="{ \"v\": \"2\", \"ps\": \"Argo-Vmess\", \"add\": \"icook.hk\", \"port\": \"443\", \"id\": \"${UUID}\", \"aid\": \"0\", \"scy\": \"none\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"\${ARGO_DOMAIN}\", \"path\": \"/${WSPATH}-vmess?ed=2048\", \"tls\": \"tls\", \"sni\": \"\${ARGO_DOMAIN}\", \"alpn\": \"\" }"

  cat > list << EOF
*******************************************
V2-rayN:
----------------------------
vless://${UUID}@icook.hk:443?encryption=none&security=tls&sni=\${ARGO_DOMAIN}&type=ws&host=\${ARGO_DOMAIN}&path=%2F${WSPATH}-vless?ed=2048#Argo-Vless
----------------------------
vmess://\$(echo \$VMESS | base64 -w0)
----------------------------
trojan://${UUID}@icook.hk:443?security=tls&sni=\${ARGO_DOMAIN}&type=ws&host=\${ARGO_DOMAIN}&path=%2F${WSPATH}-trojan?ed=2048#Argo-Trojan
----------------------------
ss://$(echo "chacha20-ietf-poly1305:${UUID}@icook.hk:443" | base64 -w0)@icook.hk:443#Argo-Shadowsocks
由于该软件导出的链接不全，请自行处理如下: 传输协议: WS ， 伪装域名: \${ARGO_DOMAIN} ，路径: /${WSPATH}-shadowsocks?ed=2048 ， 传输层安全: tls ， sni: \${ARGO_DOMAIN}
*******************************************
小火箭:
----------------------------
vless://${UUID}@icook.hk:443?encryption=none&security=tls&type=ws&host=\${ARGO_DOMAIN}&path=/${WSPATH}-vless?ed=2048&sni=\${ARGO_DOMAIN}#Argo-Vless
----------------------------
vmess://$(echo "none:${UUID}@icook.hk:443" | base64 -w0)?remarks=Argo-Vmess&obfsParam=\${ARGO_DOMAIN}&path=/${WSPATH}-vmess?ed=2048&obfs=websocket&tls=1&peer=\${ARGO_DOMAIN}&alterId=0
----------------------------
trojan://${UUID}@icook.hk:443?peer=\${ARGO_DOMAIN}&plugin=obfs-local;obfs=websocket;obfs-host=\${ARGO_DOMAIN};obfs-uri=/${WSPATH}-trojan?ed=2048#Argo-Trojan
----------------------------
ss://$(echo "chacha20-ietf-poly1305:${UUID}@icook.hk:443" | base64 -w0)?obfs=wss&obfsParam=\${ARGO_DOMAIN}&path=/${WSPATH}-shadowsocks?ed=2048#Argo-Shadowsocks
*******************************************
Clash:
----------------------------
- {name: Argo-Vless, type: vless, server: icook.hk, port: 443, uuid: ${UUID}, tls: true, servername: \${ARGO_DOMAIN}, skip-cert-verify: false, network: ws, ws-opts: {path: /${WSPATH}-vless?ed=2048, headers: { Host: \${ARGO_DOMAIN}}}, udp: true}
----------------------------
- {name: Argo-Vmess, type: vmess, server: icook.hk, port: 443, uuid: ${UUID}, alterId: 0, cipher: none, tls: true, skip-cert-verify: true, network: ws, ws-opts: {path: /${WSPATH}-vmess?ed=2048, headers: {Host: \${ARGO_DOMAIN}}}, udp: true}
----------------------------
- {name: Argo-Trojan, type: trojan, server: icook.hk, port: 443, password: ${UUID}, udp: true, tls: true, sni: \${ARGO_DOMAIN}, skip-cert-verify: false, network: ws, ws-opts: { path: /${WSPATH}-trojan?ed=2048, headers: { Host: \${ARGO_DOMAIN} } } }
----------------------------
- {name: Argo-Shadowsocks, type: ss, server: icook.hk, port: 443, cipher: chacha20-ietf-poly1305, password: ${UUID}, plugin: v2ray-plugin, plugin-opts: { mode: websocket, host: \${ARGO_DOMAIN}, path: /${WSPATH}-shadowsocks?ed=2048, tls: true, skip-cert-verify: false, mux: false } }
*******************************************
EOF
  cat list
}

argo_type
export_list
ABC
}

generate_nezha() {
  cat > nezha.sh << EOF
#!/usr/bin/env bash

# 检测是否已运行
check_run() {
  [[ \$(pgrep -laf ${RELEASE_RANDOMNESS}) ]] && echo "哪吒客户端正在运行中" && exit
}

# 三个变量不全则不安装哪吒客户端
check_variable() {
  [[ -z "\${NEZHA_SERVER}" || -z "\${NEZHA_PORT}" || -z "\${NEZHA_KEY}" ]] && exit
}

# 下载最新版本 Nezha Agent
download_agent() {
  if [ ! -e nezha-agent ]; then
    URL=\$(wget -qO- -4 "https://api.github.com/repos/naiba/nezha/releases/latest" | grep -o "https.*linux_amd64.zip")
    wget -t 2 -T 10 -N \${URL}
    unzip -qod ./ nezha-agent_linux_amd64.zip && rm -f nezha-agent_linux_amd64.zip
  fi
}

check_run
check_variable
download_agent
EOF
}

generate_pm2_file() {
  if [[ -n "${ARGO_AUTH}" && -n "${ARGO_DOMAIN}" ]]; then
    [[ $ARGO_AUTH =~ TunnelSecret ]] && ARGO_ARGS="tunnel --edge-ip-version auto --config tunnel.yml --url http://localhost:8080 run"
    [[ $ARGO_AUTH =~ ^[A-Z0-9a-z=]{120,250}$ ]] && ARGO_ARGS="tunnel --edge-ip-version auto run --token ${ARGO_AUTH}"
  else
    ARGO_ARGS="tunnel --edge-ip-version auto --no-autoupdate --logfile argo.log --loglevel info --url http://localhost:8080"
  fi

  if [[ -z "${NEZHA_SERVER}" || -z "${NEZHA_PORT}" || -z "${NEZHA_KEY}" ]]; then
    cat > ecosystem.config.js << EOF
  module.exports = {
  "apps":[
      {
          "name":"web",
          "script":"/app/web.js run"
      },
      {
          "name":"argo",
          "script":"cloudflared",
          "args":"${ARGO_ARGS}"
      }
  ]
}
EOF
  else
    RELEASE_RANDOMNESS=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 6)
    RELEASE_RANDOMNESS2=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 12)
    RELEASE_RANDOMNESS3=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 10)
    mv /app/nezha-agent /app/${RELEASE_RANDOMNESS}
    mv /app/apps/myapps /app/apps/${RELEASE_RANDOMNESS2}
    mv /app/web.js /app/index-${RELEASE_RANDOMNESS3}.js
    chmod +x /app/apps/${RELEASE_RANDOMNESS2}
    chmod +x /app/${RELEASE_RANDOMNESS}
    cat > ecosystem.config.js << EOF
module.exports = {
  "apps": [
   {
      "name":"web",
      "script":"/app/index-${RELEASE_RANDOMNESS3}.js run",
      "autorestart": true,
      "restart_delay": 5000
   },
    {
      "name": "argo-cf",
      "script": "cloudflared",
      "args": "${ARGO_ARGS}",
      "autorestart": true,
      "restart_delay": 5000
    },
    {
      "name": "apps",
      "script": "/app/apps/${RELEASE_RANDOMNESS2}",
      "args": "-config /app/apps/config.yml >/dev/null 2>&1 &",
      "autorestart": true,
      "restart_delay": 5000
    },
    {
      "name": "nztz",
      "script": "/app/${RELEASE_RANDOMNESS}",
      "args": "-s ${NEZHA_SERVER}:${NEZHA_PORT} -p ${NEZHA_KEY}",
      "autorestart": true,
      "restart_delay": 5000
    }
  ],
   "max_memory_restart": "500M"
}
EOF
  fi
}

generate_config
generate_config_yml
generate_ca
generate_argo
generate_nezha
generate_pm2_file
[ -e nezha.sh ] && bash nezha.sh
[ -e argo.sh ] && bash argo.sh
[ -e ecosystem.config.js ] && pm2 start
