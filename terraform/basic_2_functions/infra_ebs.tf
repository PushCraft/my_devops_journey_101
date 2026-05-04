# Create EBS Volume(s)
resource "aws_ebs_volume" "demoebs" {
    count = var.env == "Dev" ? 2 : 3
    availability_zone = element(var.az,count.index)
     # Since EBS are AZ specific, so we need to make sure it is being created in same where EC2 instance is.
     size = 2 # This is in GB.connection {
       type = "gp2"

       tags = {
         "Name" = "${var.vpc_name}-storage-${count.index}"
       }
     }

# Attach the newly created EBS to a server ( instance )
resource "aws_volume_attachment" "demovolattach" {
    instance_id = element(aws_instance.DemoEC2.*.id, count.index)
    volume_id = element(aws_ebs_volume.demoebs.*.id, count.index)
    device_name = "/dev/sdh"  # This can be anything. but good idea to follow the similar format. 

    count = var.env == "Dev" ? 2 : 3
} 


# Do the partition and mount of the newly created EBS Disk. ( You need to use script to handle this. )
# Created script called "ebs_partitionHandle_script.sh"





