rule simple {

  when HTTP_REQUEST {
    if { [HTTP::uri] starts_with "/foo" } {
      pool foo
    } else {
      pool bar
    }
  }

  when HTTP_RESPONSE {
    HTTP::header remove "Vary"
    HTTP::header insert Vary "Accept-Encoding"
  }

}