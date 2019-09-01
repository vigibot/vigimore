## Content

The files in this folder are drawings exported as SCAD profiles (2D polygons) in generated folder

## HowTo

* Install Inkscape to open svg to convert:
	* https://inkscape.org/
* Install this plugin in Inkscape: [paths2openscad](https://github.com/fablabnbg/inkscape-paths2openscad)
        * files:  `paths2openscad.inx` and `paths2openscad.py`
        * target: `C:\Program Files (x86)\Inkscape\share\extensions\`

* From Inkscape you are now able to export to OpenSCAD format:
    * Lock all layers but layer "Main" and "Reference"
    * Select ALL in ALL layers shapes: <Ctrl+Alt+a>
        * This selects shapes in layer "Main" and "Reference"
    * "Extensions" -> "Generate from path" -> "Paths to OpenSCAD":
        * Specify the name of the file to generate
        * Select option "Only create a module"

## Note

* With a svg viewer you can only see one quarter of files because the viewport is centered on every drawing
    * This is a constraint for correct coordinates in exportes scad files
