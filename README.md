
# README

## Template sources
Most skins came from http://www.styleshout.com/, with the exception of the 
gh_default skin, which was created with GitHub's automatic page generator.

## TBD
- Templatized skins
  - gh_default
  - sparrow
  - keepitsimple
- Still need to be templatized
  - pageone
  - freshpick
- After templatizing a skin, remove its branch.

All skins, including the ones that have been templatized, have a large amount of 
boilerplate/lorem text that needs to be swapped out for real text.

## Dump website with a different skin
Edit make.pl -- uncomment the ``$skin = 'SKIN_YOU_WANT';`` and be sure the other ``$skin`` 
assignments are commented.  Then run make.pl.  All current .html files will be replaced by 
files using that skin.

## Set up a new skin
    - Name it.
        - For consistency, go with one word, all lc

    - mkdir tmpl/NAME
    - mkdir skins/NAME

    - Create or download your template from wherever.  Put it into tmpl/NAME/
    - Move all of the media (images, css, js, etc) into skins/NAME/
        - You're usually going to be moving a whole directory.
          mv images/ ../../skins/NAME/
          mv css/ ../../skins/NAME/
          etc
    - Make sure the template-specific variables in make.pl include an 'inc' 
      key, which must be set to "skins/NAME/"
        - No slash at the beginning, must have slash at the end.
        - All links to media files within your new template set must link to 
          here.  eg:
            - <img src="skins/NAME/images/foo.jpg">
            - <link rel="stylesheet" href="skins/NAME/css/default.css">
            - <script src="skins/NAME/js/script.js"></script>

    - Any image links in data ($vars in make.pl) should NOT include the 
      "skins/NAME/" prefix.  Let the templates add those.

