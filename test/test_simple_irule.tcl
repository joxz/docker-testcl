package require -exact testcl 1.0.14
namespace import ::testcl::*

# Comment in to enable logging
#log::lvSuppressLE info 0

it "should handle request using pool bar" {
  event HTTP_REQUEST
  on HTTP::uri return "/bar"
  endstate pool bar
  run simple_irule.tcl simple
}

it "should handle request using pool foo" {
  event HTTP_REQUEST
  on HTTP::uri return "/foo/admin"
  endstate pool foo
  run simple_irule.tcl simple
}

it "should replace existing Vary http response headers with Accept-Encoding value" {
  event HTTP_RESPONSE
  verify "there should be only one Vary header" 1 == {HTTP::header count vary}
  verify "there should be Accept-Encoding value in Vary header" "Accept-Encoding" eq {HTTP::header Vary}
  HTTP::header insert Vary "dummy value"
  HTTP::header insert Vary "another dummy value"
  run simple_irule.tcl simple
}