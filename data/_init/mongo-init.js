db = db.getSiblingDB('admin')
db.createUser({
    user: "backup",
    pwd: "backup_password",
    roles: [ "backup" ]
})
