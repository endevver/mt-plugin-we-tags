
package WeTags::Comments;

use strict;
use warnings;

sub __result {
    my $app = shift;
    my ($results) = @_;

    $app->json_result($results);
}

sub __error {
    my $app = shift;
    my ($msg) = @_;

    return $app->json_error($msg);
}

sub add_tag {
    my $app = shift;

    my $type = $app->param('_type') || 'entry';
    my $id   = $app->param('id');
    my $tag  = $app->param('tag');

    return __error( $app, "Object id required" ) if ( !$id );
    return __error( $app, "Tag required" )       if ( !$tag );

    my $class = MT->model($type);
    my $obj   = $class->load($id);

    return __error( $app, "Object not found" ) unless $obj;
    return __error( $app, "Object not taggable" )
        unless $obj->can('add_tags');

    $app->param( 'blog_id', $obj->blog_id )
        if ( !$app->param('blog_id') && $obj->can('blog_id') );

    my ( $sess_obj, $user ) = $app->get_commenter_session();
    return __error( $app, "Login required" )
        if ( $app->config->WeTagsLoginRequired && !$user );

    $obj->add_tags($tag);
    $obj->save
        or return __error( $app, "Error saving object: " . $obj->errstr );

    if ( $type eq 'entry' && $app->config->WeTagsRebuildEntries ) {
        require MT::Util;

        # we should rebuild it
        MT::Util::start_background_task(
            sub {
                $app->rebuild_entry(
                    Entry => $obj,
                    (   $app->config->WeTagsRebuildIndexes
                        ? ( BuildIndexes => 1 )
                        : ()
                    )
                );
            }
        );
    }

    return __result( $app, { message => 'Success', tag_added => $tag } );
}

1;
