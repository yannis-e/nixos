{
  foot,
}:
foot.overrideAttrs (oldAttrs: {
  pname = "${oldAttrs.pname}-transparency";
  patches = oldAttrs.patches or [ ] ++ [ ./transparency.patch ];
})
