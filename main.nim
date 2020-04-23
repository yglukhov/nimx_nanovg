import nimx/[window, layout, view, animation]
import nanovg
import nanovg/wrapper
import opengl/private/prelude
import times
import demo

var vg: NVGContext
type MyView = ref object of View

var demoData: DemoData

method draw*(v: MyView, r: Rect) =
  procCall v.View.draw(r)
  vg.beginFrame(v.bounds.width, v.bounds.height, 1.0)
  renderDemo(vg, 0, 0, v.bounds.width, v.bounds.height, epochTime(), false, demoData)
  vg.endFrame()

proc nvgInit(flags: set[NvgInitFlag] = {}): NVGContext =
  when defined(ios) or defined(android):
    result = nvgCreateContext(flags)
  else:
    result = nvgInit(glGetProc)

proc startApp() =
  # First create a window. Window is the root of view hierarchy.
  var wnd = newWindow(newRect(40, 40, 800, 600))
  wnd.makeLayout:
    title: "Nanovg example"
    - MyView:
      frame == super

  vg = nvgInit()

  # Asset loading is slightly more involved on the following platforms, so we just don't try at all.
  when not (defined(android) or defined(ios) or defined(emscripten) or defined(wasm)):
    if not vg.loadDemoData(demoData):
      raise newException(ValueError, "Could not load demo data")

  wnd.addAnimation(newAnimation())

# Run the app
runApplication:
    startApp()
