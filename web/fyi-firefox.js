javascript:var%20e='user@domain.tld',a='%250A',c=encodeURIComponent(document.title),d=window.getSelection(),b='%s';b.length%3C3&&(b=window.prompt('Send%20link%20to%20email%20address(es):',e)),''!==b&&(location.href='mailto:'+b+'?subject=fyi:%20'+c+'&body='+c+a+location.href+a+(d?'---'+a+encodeURIComponent(d)+a+a:a));void'2.7.1ff'