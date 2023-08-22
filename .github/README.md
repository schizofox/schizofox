# 🥑 Schizofox
*our goal is to get on the CIA watchlist*

<p align="center">
<img src="../assets/ss.png" alt="screenshot" width="600" align="center" />  
<img src="../assets/glowie.jpg" alt="screenshot" width="400" align="center" />  
</p>

## About
Hey, so this configuration started as a part of my [dotfiles repo](https://github.com/sioodmy/dotfiles), but apparently people actually used it, so I decided to move it into its own flake.
Compared to other browsers/configuration I would say its pretty schizophrenic, but I use it as my daily driver, so I had to keep some sane defaults (if you really need to, just use Tor Browser).
Another cool thing is declarative theming. Just specify 3 colors and your font of choice and nix will do the rest (userChrome.css and darkreader config). 

⚠️ Tip: Use Ctrl+I to allow cookies for sites of your choice

Make sure to submit an issue in case anything brakes (or contribute if you know how to fix it)

## 💛 Donate

If you would like to support me you can sponsor me via ko-fi

<a href="https://ko-fi.com/sioodmy"><img src="https://ko-fi.com/img/githubbutton_sm.svg" alt="Support me on kofi" /> </a>

## Configuration
```nix
programs.schizofox = {
  enable = true;
  userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:106.0) Gecko/20100101 Firefox/106.0";
  background-darker = "181825";
  background = "1e1e2e";
  foreground = "cdd6f4";
  font = "Lexend";
  defaultSearchEngine = "Brave";
  removeEngines = ["Google" "Bing" "Amazon.com" "eBay" "Twitter" "Wikipedia"];
  searxQuery = "https://searx.be/search?q={searchTerms}&categories=general";
  sanitizeOnShutdown = false;
  drmFix = true;
  disableWebgl = false;
}
```



## Credits <3
[NotAShelf](https://github.com/NotAShelf)
