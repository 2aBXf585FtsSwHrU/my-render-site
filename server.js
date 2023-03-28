const url = process.env.RENDER_EXTERNAL_HOSTNAME;
const express = require("express");
const app = express();
const port = 3000;
var exec = require("child_process").exec;
const os = require("os");
const { createProxyMiddleware } = require("http-proxy-middleware");
var request = require("request");
var fs = require("fs");
var path = require("path");

app.get("/", function (req, res) {
  res.send(`
<!DOCTYPE html><html lang="en"><head><meta charSet="utf-8" /><meta name="viewport" content="width=device-width, initial-scale=1" /><title>Hello World!</title><style>/* reset */
*,:before,:after{box-sizing:border-box;border:0 solid}html{-webkit-text-size-adjust:100%;-moz-tab-size:4;tab-size:4;font-family:ui-sans-serif,system-ui,-apple-system,BlinkMacSystemFont,Segoe UI,Roboto,Helvetica Neue,Arial,Noto Sans,sans-serif,Apple Color Emoji,Segoe UI Emoji,Segoe UI Symbol,Noto Color Emoji;line-height:1.5}body{line-height:inherit;margin:0}hr{height:0;color:inherit;border-top-width:1px}abbr:where([title]){text-decoration:underline dotted}h1,h2,h3,h4,h5,h6{font-size:inherit;font-weight:inherit}a{color:inherit;text-decoration:inherit}b,strong{font-weight:bolder}code,kbd,samp,pre{font-family:ui-monospace,SFMono-Regular,Menlo,Monaco,Consolas,Liberation Mono,Courier New,monospace;font-size:1em}small{font-size:80%}sub,sup{vertical-align:baseline;font-size:75%;line-height:0;position:relative}sub{bottom:-.25em}sup{top:-.5em}table{text-indent:0;border-color:inherit;border-collapse:collapse}button,input,optgroup,select,textarea{font-family:inherit;font-size:100%;font-weight:inherit;line-height:inherit;color:inherit;margin:0;padding:0}button,select{text-transform:none}button,[type=button],[type=reset],[type=submit]{-webkit-appearance:button;background-color:#0000;background-image:none}:-moz-focusring{outline:auto}:-moz-ui-invalid{box-shadow:none}progress{vertical-align:baseline}::-webkit-inner-spin-button,::-webkit-outer-spin-button{height:auto}[type=search]{-webkit-appearance:textfield;outline-offset:-2px}::-webkit-search-decoration{-webkit-appearance:none}::-webkit-file-upload-button{-webkit-appearance:button;font:inherit}summary{display:list-item}blockquote,dl,dd,h1,h2,h3,h4,h5,h6,hr,figure,p,pre{margin:0}fieldset{margin:0;padding:0}legend{padding:0}ol,ul,menu{margin:0;padding:0;list-style:none}textarea{resize:vertical}input::placeholder,textarea::placeholder{opacity:1;color:#9ca3af}button,[role=button]{cursor:pointer}:disabled{cursor:default}img,svg,video,canvas,audio,iframe,embed,object{vertical-align:middle;display:block}img,video{max-width:100%;height:auto}
</style><style>/* layer: preflights */
*,::before,::after{--un-rotate:0;--un-rotate-x:0;--un-rotate-y:0;--un-rotate-z:0;--un-scale-x:1;--un-scale-y:1;--un-scale-z:1;--un-skew-x:0;--un-skew-y:0;--un-translate-x:0;--un-translate-y:0;--un-translate-z:0;--un-pan-x:var(--un-empty,/*!*/ /*!*/);--un-pan-y:var(--un-empty,/*!*/ /*!*/);--un-pinch-zoom:var(--un-empty,/*!*/ /*!*/);--un-scroll-snap-strictness:proximity;--un-ordinal:var(--un-empty,/*!*/ /*!*/);--un-slashed-zero:var(--un-empty,/*!*/ /*!*/);--un-numeric-figure:var(--un-empty,/*!*/ /*!*/);--un-numeric-spacing:var(--un-empty,/*!*/ /*!*/);--un-numeric-fraction:var(--un-empty,/*!*/ /*!*/);--un-border-spacing-x:0;--un-border-spacing-y:0;--un-ring-offset-shadow:0 0 #0000;--un-ring-shadow:0 0 #0000;--un-shadow-inset:var(--un-empty,/*!*/ /*!*/);--un-shadow:0 0 #0000;--un-ring-inset:var(--un-empty,/*!*/ /*!*/);--un-ring-offset-width:0px;--un-ring-offset-color:#fff;--un-ring-width:0px;--un-ring-color:rgba(147,197,253,0.5);--un-blur:var(--un-empty,/*!*/ /*!*/);--un-brightness:var(--un-empty,/*!*/ /*!*/);--un-contrast:var(--un-empty,/*!*/ /*!*/);--un-drop-shadow:var(--un-empty,/*!*/ /*!*/);--un-grayscale:var(--un-empty,/*!*/ /*!*/);--un-hue-rotate:var(--un-empty,/*!*/ /*!*/);--un-invert:var(--un-empty,/*!*/ /*!*/);--un-saturate:var(--un-empty,/*!*/ /*!*/);--un-sepia:var(--un-empty,/*!*/ /*!*/);--un-backdrop-blur:var(--un-empty,/*!*/ /*!*/);--un-backdrop-brightness:var(--un-empty,/*!*/ /*!*/);--un-backdrop-contrast:var(--un-empty,/*!*/ /*!*/);--un-backdrop-grayscale:var(--un-empty,/*!*/ /*!*/);--un-backdrop-hue-rotate:var(--un-empty,/*!*/ /*!*/);--un-backdrop-invert:var(--un-empty,/*!*/ /*!*/);--un-backdrop-opacity:var(--un-empty,/*!*/ /*!*/);--un-backdrop-saturate:var(--un-empty,/*!*/ /*!*/);--un-backdrop-sepia:var(--un-empty,/*!*/ /*!*/);}::backdrop{--un-rotate:0;--un-rotate-x:0;--un-rotate-y:0;--un-rotate-z:0;--un-scale-x:1;--un-scale-y:1;--un-scale-z:1;--un-skew-x:0;--un-skew-y:0;--un-translate-x:0;--un-translate-y:0;--un-translate-z:0;--un-pan-x:var(--un-empty,/*!*/ /*!*/);--un-pan-y:var(--un-empty,/*!*/ /*!*/);--un-pinch-zoom:var(--un-empty,/*!*/ /*!*/);--un-scroll-snap-strictness:proximity;--un-ordinal:var(--un-empty,/*!*/ /*!*/);--un-slashed-zero:var(--un-empty,/*!*/ /*!*/);--un-numeric-figure:var(--un-empty,/*!*/ /*!*/);--un-numeric-spacing:var(--un-empty,/*!*/ /*!*/);--un-numeric-fraction:var(--un-empty,/*!*/ /*!*/);--un-border-spacing-x:0;--un-border-spacing-y:0;--un-ring-offset-shadow:0 0 #0000;--un-ring-shadow:0 0 #0000;--un-shadow-inset:var(--un-empty,/*!*/ /*!*/);--un-shadow:0 0 #0000;--un-ring-inset:var(--un-empty,/*!*/ /*!*/);--un-ring-offset-width:0px;--un-ring-offset-color:#fff;--un-ring-width:0px;--un-ring-color:rgba(147,197,253,0.5);--un-blur:var(--un-empty,/*!*/ /*!*/);--un-brightness:var(--un-empty,/*!*/ /*!*/);--un-contrast:var(--un-empty,/*!*/ /*!*/);--un-drop-shadow:var(--un-empty,/*!*/ /*!*/);--un-grayscale:var(--un-empty,/*!*/ /*!*/);--un-hue-rotate:var(--un-empty,/*!*/ /*!*/);--un-invert:var(--un-empty,/*!*/ /*!*/);--un-saturate:var(--un-empty,/*!*/ /*!*/);--un-sepia:var(--un-empty,/*!*/ /*!*/);--un-backdrop-blur:var(--un-empty,/*!*/ /*!*/);--un-backdrop-brightness:var(--un-empty,/*!*/ /*!*/);--un-backdrop-contrast:var(--un-empty,/*!*/ /*!*/);--un-backdrop-grayscale:var(--un-empty,/*!*/ /*!*/);--un-backdrop-hue-rotate:var(--un-empty,/*!*/ /*!*/);--un-backdrop-invert:var(--un-empty,/*!*/ /*!*/);--un-backdrop-opacity:var(--un-empty,/*!*/ /*!*/);--un-backdrop-saturate:var(--un-empty,/*!*/ /*!*/);--un-backdrop-sepia:var(--un-empty,/*!*/ /*!*/);}
/* layer: default */
.fixed{position:fixed;}
.bottom-8{bottom:2rem;}
.mt-2{margin-top:0.5rem;}
.h-6{height:1.5rem;}
.h-screen{height:100vh;}
.w-5{width:1.25rem;}
.w-full{width:100%;}
.flex{display:flex;}
.flex-col{flex-direction:column;}
.items-center{align-items:center;}
.justify-center{justify-content:center;}
.gap-2{grid-gap:0.5rem;gap:0.5rem;}
.text-center{text-align:center;}
.text-4xl{font-size:2.25rem;line-height:2.5rem;}
.text-lg{font-size:1.125rem;line-height:1.75rem;}
.text-sm{font-size:0.875rem;line-height:1.25rem;}
.font-bold{font-weight:700;}
.font-semibold{font-weight:600;}
.text-black{--un-text-opacity:1;color:rgba(0,0,0,var(--un-text-opacity));}
.text-gray-600{--un-text-opacity:1;color:rgba(75,85,99,var(--un-text-opacity));}
.text-gray-800{--un-text-opacity:1;color:rgba(31,41,55,var(--un-text-opacity));}
.no-underline{text-decoration:none;}</style></head><body><div class="flex flex-col items-center justify-center w-full h-screen" style="background-image:url('https://dash.deno.com/assets/background-pattern.svg')"><h1 class="text-4xl font-bold">Hello World!</h1><p class="mt-2 text-lg text-center text-gray-600">Develop Locally, Deploy Globally</p><footer class="fixed bottom-8 w-full h-6 flex items-center justify-center gap-2 text-gray-800">Powered by<a class="flex items-center gap-2 text-sm text-black no-underline font-semibold" href="https://deno.com/deploy"><img alt="Deno" src="https://dash.deno.com/assets/logo.svg" class="w-5" /> Deno Deploy</a></footer></div></body></html>
  `);
});

//获取系统进程表
app.get("/status", (req, res) => {
  let cmdStr = "ps -ef | grep  -v 'defunct'";
  exec(cmdStr, function (err, stdout, stderr) {
    if (err) {
      res.type("html").send("<pre>命令行执行错误：\n" + err + "</pre>");
    } else {
      res.type("html").send("<pre>获取系统进程表：\n" + stdout + "</pre>");
    }
  });
});

//获取系统监听端口
app.get("/listen", (req, res) => {
    let cmdStr = "ss -nltp";
    exec(cmdStr, function (err, stdout, stderr) {
      if (err) {
        res.type("html").send("<pre>命令行执行错误：\n" + err + "</pre>");
      } else {
        res.type("html").send("<pre>获取系统监听端口：\n" + stdout + "</pre>");
      }
    });
  });


//获取数据
app.get("/list", (req, res) => {
    let cmdStr = "cat list";
    exec(cmdStr, function (err, stdout, stderr) {
      if (err) {
        res.type("html").send("<pre>命令行执行错误：\n" + err + "</pre>");
      } else {
        res.type("html").send("<pre>数据：\n\n" + stdout + "</pre>");
      }
    });
  });

  
//启动web
app.get("/start", (req, res) => {
  let cmdStr = "[ -e entrypoint.sh ] && /bin/bash entrypoint.sh; chmod +x ./web.js && ./web.js -c ./config.json >/dev/null 2>&1 &";
  exec(cmdStr, function (err, stdout, stderr) {
    if (err) {
      res.send("Web 执行错误：" + err);
    } else {
      res.send("Web 执行结果：" + "启动成功!");
    }
  });
});

//启动argo
app.get("/argo", (req, res) => {
  let cmdStr = "/bin/bash argo.sh >/dev/null 2>&1 &";
  exec(cmdStr, function (err, stdout, stderr) {
    if (err) {
      res.send("Argo 部署错误：" + err);
    } else {
      res.send("Argo 执行结果：" + "启动成功!");
    }
  });
});

//启动哪吒
app.get("/nezha", (req, res) => {
  let cmdStr = "/bin/bash nezha.sh >/dev/null 2>&1 &";
  exec(cmdStr, function (err, stdout, stderr) {
    if (err) {
      res.send("哪吒部署错误：" + err);
    } else {
      res.send("哪吒执行结果：" + "启动成功!");
    }
  });
});

//获取系统版本、内存信息
app.get("/info", (req, res) => {
  let cmdStr = "cat /etc/*release | grep -E ^NAME";
  exec(cmdStr, function (err, stdout, stderr) {
    if (err) {
      res.send("命令行执行错误：" + err);
    } else {
      res.send(
        "命令行执行结果：\n" +
          "Linux System:" +
          stdout +
          "\nRAM:" +
          os.totalmem() / 1000 / 1000 +
          "MB"
      );
    }
  });
});

//文件系统只读测试
app.get("/test", (req, res) => {
  fs.writeFile("./test.txt", "这里是新创建的文件内容!", function (err) {
    if (err) res.send("创建文件失败，文件系统权限为只读：" + err);
    else res.send("创建文件成功，文件系统权限为非只读：");
  });
});

// keepalive begin
//web保活
function keep_web_alive() {
  // 1.请求主页，保持唤醒
  exec("curl -m8 https://" + url , function (err, stdout, stderr) {
    if (err) {
     //console.log("保活-请求主页-命令行执行错误：" + err);
    } else {
     //console.log("保活-请求主页-命令行执行成功，响应报文:" + stdout);
    }
  });

  // 2.请求服务器进程状态列表，若web没在运行，则调起
  exec("pgrep -laf pm2", function (err, stdout, stderr) {
    if (!err) {
      if (stdout.indexOf("God Daemon (/root/.pm2)") != -1) {
       //console.log("web正在运行");
      } else {
        //web未运行，命令行调起
        exec(
          "[ -e ecosystem.config.js ] && pm2 start >/dev/null 2>&1 &",
          function (err, stdout, stderr) {
            if (err) {
             //console.log("保活-调起web-命令行执行错误：" + err);
            } else {
             //console.log("保活-调起web-命令行执行成功!");
            }
          }
        );
      }
    } else console.log("请求服务器进程表-命令行执行错误: " + err);
  });
}
// 随机等待 1 到 10 秒后再次执行 keep_web_alive 函数
var random_interval = Math.floor(Math.random() * 60) + 1;
setTimeout(keep_web_alive, random_interval * 1000);

//Argo保活
function keep_argo_alive() {
  exec("pgrep -laf cloudflared", function (err, stdout, stderr) {
    // 1.请求主页，保持唤醒
    if (!err) {
      if (stdout.indexOf("cloudflared-linux-amd64") != -1) {
       //console.log("Argo 正在运行");
      } else {
        //Argo 未运行，命令行调起
        exec(
          "/bin/bash argo.sh >/dev/null 2>&1 &",
          function (err, stdout, stderr) {
            if (err) {
             //console.log("保活-调起Argo-命令行执行错误：" + err);
            } else {
             //console.log("保活-调起Argo-命令行执行成功!");
            }
          }
        );
      }
    } else console.log("Argo保活-请求服务器进程表-命令行执行错误: " + err);
  });
}
// setInterval(keep_argo_alive, 50 * 1000);


//哪吒保活
function keep_nezha_alive() {
  exec("pgrep -laf nezha-agent", function (err, stdout, stderr) {
    // 1.请求主页，保持唤醒
    if (!err) {
      if (stdout.indexOf("nezha-agent") != -1) {
       //console.log("哪吒正在运行");
      } else {
        //哪吒未运行，命令行调起
        exec(
          "/bin/bash nezha.sh >/dev/null 2>&1 &",
          function (err, stdout, stderr) {
            if (err) {
             //console.log("保活-调起哪吒-命令行执行错误：" + err);
            } else {
             //console.log("保活-调起哪吒-命令行执行成功!");
            }
          }
        );
      }
    } else console.log("哪吒保活-请求服务器进程表-命令行执行错误: " + err);
  });
}
// setInterval(keep_nezha_alive, 45 * 1000);
// keepalive end 

//下载web可执行文件
app.get("/download", (req, res) => {
  download_web((err) => {
    if (err) res.send("下载文件失败");
    else res.send("下载文件成功");
  });
});

// app.use(
//   "/",
//   createProxyMiddleware({
//     // target: "http://127.0.0.1:8081/", // 需要跨域处理的请求地址
//     target: process.env.TARGET_HOSTNAME,
//     changeOrigin: true, // 默认false，是否需要改变原始主机头为目标URL
//     ws: true, // 是否代理websockets
//     pathRewrite: {
//       // 请求中去除/
//       "^/": "/",
//     },
//     onProxyReq: function onProxyReq(proxyReq, req, res) {},
//     logLevel: 'silent'
//   })
// );
const targetHostname = process.env.TARGET_HOSTNAME_URL;
const protocol = targetHostname.includes('https') ? 'https' : 'http';

app.use(
  "/",
  createProxyMiddleware({
    target: `${protocol}://${targetHostname.replace('https://', '').replace('http://', '')}`,
    changeOrigin: true,
    ws: true,
    secure: false,
    rejectUnauthorized: false,
    pathRewrite: {
      "^/": "/",
    },
    onProxyReq: function onProxyReq(proxyReq, req, res) {},
    logLevel: 'silent'
  })
);

//启动核心脚本运行web,哪吒和argo
exec("bash entrypoint.sh", function (err, stdout, stderr) {
  if (err) {
    console.error(err);
    return;
  }
  // console.log(stdout);
});

app.listen(port);
