local sgPresent, sg = pcall(require, "sg")

if not sgPresent then
	return
end

-- Sourcegraph configuration. All keys are optional
sg.setup {
  -- Pass your own custom attach function
  --    If you do not pass your own attach function, then the following maps are provide:
  --        - gd -> goto definition
  --        - gr -> goto references
  -- on_attach = {}
}
