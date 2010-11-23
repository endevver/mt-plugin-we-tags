
## Configuration Settings

* WeTagsLoginRequired

  Require logged in user to add tags through the community pack.
  
  Defaults to 1.
  
## Tags

None

## UI Changes

None

## Community Pack changes

Added add_tags method.  Takes _type (defaults to 'entry'), id and tag arguments.  Returns either JSON or JSONP call (if passed a jsonp argument).  On success returns:

 

    {
        error => undef,
        result => {
                      message => 'Success',
                      tag_added => '<tag that was added>'
                  }
    }

