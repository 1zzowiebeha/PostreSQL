The postgres database is a default database meant for use by users, utilities and third party applications. 

template1 and template0 are meant as source databases to be copied by later CREATE DATABASE commands.
template0 should never be modified, but you can add objects to template1, which by default will be copied into databases created later. See Section 23.3 for more details.