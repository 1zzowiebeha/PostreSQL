
a user gets privilieges from
groups it is a member of, those granted directly, and from PUBLIC.

if a role is a member of a group with a privilege, but the same privilege is revoked from PUBLIC, it will still have that privilege from its group.

If a user holds a privilege with grant option and has granted it to other users then the privileges held by those other users are called dependent privileges. If the privilege or the grant option held by the first user is being revoked and dependent privileges exist, those dependent privileges are also revoked if CASCADE is specified