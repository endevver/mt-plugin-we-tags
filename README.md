
## Configuration Settings

* WeTagsLoginRequired

  Require logged in user to add tags through the community pack.
  
  Defaults to 1.
  
* WeTagsRebuildEntries

  Rebuild tagged entries (in the background if possible).
  
  Defaults to 1.
  
## Tags

None

## UI Changes

None

## Comments application changes

Added add_tag method.  Takes _type (defaults to 'entry'), id and tag arguments.  Returns JSON.  On success returns:

 

    {
        error => undef,
        result => {
                      message => 'Success',
                      tag_added => '<tag that was added>'
                  }
    }

