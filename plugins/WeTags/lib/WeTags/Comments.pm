
package WeTags::Community;

use strict;
use warnings;

sub __result {
    my $app = shift;
    my ($results) = @_;

    my $jsonp = $app->param('jsonp');
    if ($jsonp) {
        $app->jsonp_result( $results, $jsonp );
    }
    else {
        $app->json_result($results);
    }
}

sub __error {
    my $app = shift;
    my ($msg) = @_;

    my $jsonp = $app->param('jsonp');
    if ($jsonp) {
        return $app->jsonp_error( $msg, $jsonp );
    }
    else {
        return $app->json_error($msg);
    }
}

sub add_tag {
    my $app = shift;

    my $jsonp = $app->param('jsonp');

    my $user = $app->_login_user_commenter();
    return __error( $app, "Login required" )
        if ( $app->config->WeTagsLoginRequired && !$user );

    my $type = $app->param('_type') && 'entry';
    my $id   = $app->param('id');
    my $tag  = $app->param('tag');

    return __error( $app, "Object id required" ) if ( !$id );
    return __error( $app, "Tag required" )       if ( !$tag );

    my $class = MT->model($type);
    my $obj   = $class->load($id);

    return __error( $app, "Object not found" ) unless $obj;
    return __error( $app, "Object not taggable" )
        unless $obj->can('add_tags');

    $obj->add_tags($tag);
    $obj->save
        or return __error( $app, "Error saving object: " . $obj->errstr );

    return { message => 'Success', tag_added => $tag };
}

1;