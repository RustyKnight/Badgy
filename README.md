#  Badgy

`Badgy` is a simple mac command line utility that adds a text "banner" and "alpha" or "beta" badge to the App icon

"But wait, there's already a tool that does this, [HazAT/badge](https://github.com/HazAT/badge), why shouldn't I just use it instead?", you say.

The answer is simple.  You should.  If it works for you and does the job you need it to, then you should use it, it's really great.

"But if it's so great, why did you create Badgy?", you ask.

Well, simply, it wasn't working for me, not entirely.

* I didn't like the fact that the banner didn't occupy more vertical space, taking into consideration the bezel applied by Apple, which often cropped the text or forced me to offset the banner in a way that didn't really look nice (okay, this is a highlight to the user that this is not a app store version of the app, but why can't I have it look nice?)
* The text can "collapse" in on itself if it's long.  I was simply putting the version and build number across the top of the banner and found that some version values would "collapse" if the text was to long.  This is probably a mixture of issues with SVG and image majic
* I don't like that it doesn't, some how, make backups of the original icons and continue to use those when creating new badges - it's a nick pick, but it makes the build process a little more complicated - especially when you're releasing to multiple destinations and they have different business rules

![Assets/BadgedIcon.png](Assets/BadgedIcon.png?raw=1)

```Badgy --help
USAGE: badge-it [--backup] [--restore] [--clean] [--asset-path <asset-path>] [--badge-style <badge-style>] [<main-text>] [<sub-text>]

ARGUMENTS:
  <main-text>             Main banner text 
  <sub-text>              Sub banner text 

OPTIONS:
  --backup                Back up the original App icons (if not already done) 
  --restore               Restore the original App icons (if back up exists - overwrites the existing icons) 
  --clean                 Remove backups 
  --asset-path <asset-path>
                          The path to the App Icon asset catalog (*.xcassets directory), will use current directly if not specified 
  --badge-style <badge-style>
                          Badge style, alpha[Light/Dark], beta[Light/Dark] 
  -h, --help              Show help information.```
