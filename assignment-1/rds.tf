resource "aws_db_subnet_group" "mysqldb-subnet" {
  name        = "mysqldb-subnet"
  description = "RDS subnet group"
  subnet_ids  = [aws_subnet.astro-private-db-1.id, aws_subnet.astro-private-db-2.id]
}

resource "aws_db_parameter_group" "mysqldb-parameters" {
  name        = "mysqldb-parameters"
  family      = "mysql8.0"
  description = "mysqldb parameter group"

  parameter {
    name  = "max_allowed_packet"
    value = "16777216"
  }
}

resource "aws_db_instance" "astro-mysql" {
  allocated_storage       = 100 # 100 GB of storage, gives us more IOPS than a lower number
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t2.small" # use micro if you want to use the free tier
  identifier              = "mysql"
  db_name                    = "astrodb" #dbname
  username                = "root"           # username
  password                = var.RDS_PASSWORD # password
  db_subnet_group_name    = aws_db_subnet_group.mysqldb-subnet.name
  parameter_group_name    = aws_db_parameter_group.mysqldb-parameters.name
  multi_az                = "false" # set to true to have high availability: 2 instances synchronized with each other
  vpc_security_group_ids  = [aws_security_group.astro-mysql-sg.id]
  storage_type            = "gp2"
  backup_retention_period = 30                                          # how long you’re going to keep your backups
  availability_zone       = aws_subnet.astro-private-db-1.availability_zone # prefered AZ
  skip_final_snapshot     = true                                        # skip final snapshot when doing terraform destroy
  tags = {
    Name = "astro-mysql-test"
  }
}