output "invite_user" {
    description = "Users that was invited to the project"
    value = zipmap( values(ibm_iam_user.invite_user[*].id), values(ibm_iam_user.invite_user[*].email) )
    # value = ibm_iam_user_invite.invite_user.*.id
}