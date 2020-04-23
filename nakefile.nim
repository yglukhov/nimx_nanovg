import nimx/naketools

beforeBuild = proc(b: Builder) =
  if b.platform in ["android", "ios", "ios-sim"]:
    b.additionalNimFlags.add("-d:nvgGLES3")
  else:
    b.additionalNimFlags.add("-d:nvgGL3")
