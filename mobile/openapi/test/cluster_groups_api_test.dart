import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for ClusterGroupsApi
void main() {
  final instance = Openapi().getClusterGroupsApi();

  group(ClusterGroupsApi, () {
    // Accept a cluster group request
    //
    // Join the cluster group the request was created for.
    //
    //Future acceptClusterGroupRequest(String id) async
    test('test acceptClusterGroupRequest', () async {
      // TODO
    });

    // Regenerate people of users in cluster group
    //
    // Forcefully re-run facial recognition for all faces of users in this group.
    //
    //Future clusterGroupRegeneratePeople(String id) async
    test('test clusterGroupRegeneratePeople', () async {
      // TODO
    });

    // Create a cluster group request
    //
    // Ask another user to join the cluster group of the current user.
    //
    //Future<ClusterGroupRequestResponseDto> createClusterGroupRequest(String id, ClusterGroupRequestCreateDto clusterGroupRequestCreateDto) async
    test('test createClusterGroupRequest', () async {
      // TODO
    });

    // Decline a cluster group request
    //
    // Delete a pending request to join a cluster group.
    //
    //Future deleteClusterGroupRequest(String id) async
    test('test deleteClusterGroupRequest', () async {
      // TODO
    });

    // Retrieve cluster group requests
    //
    // Retrieve the pending requests for the current user to join a cluster group.
    //
    //Future<BuiltList<ClusterGroupRequestResponseDto>> getClusterGroupRequests() async
    test('test getClusterGroupRequests', () async {
      // TODO
    });

    // Retrieve the requests sent by a cluster group
    //
    // Retrieve the pending requests for other users to join the cluster group.
    //
    //Future<BuiltList<ClusterGroupRequestResponseDto>> getClusterGroupRequestsForGroup(String id) async
    test('test getClusterGroupRequestsForGroup', () async {
      // TODO
    });

    // Retrieve the users of a cluster group
    //
    // Retrieve the users that are a member of the cluster group.
    //
    //Future<BuiltList<UserResponseDto>> getClusterGroupUsers(String id) async
    test('test getClusterGroupUsers', () async {
      // TODO
    });

    // Leave a cluster group
    //
    // Move the current user into a new cluster group of their own.
    //
    //Future leaveClusterGroup(String id) async
    test('test leaveClusterGroup', () async {
      // TODO
    });

  });
}
