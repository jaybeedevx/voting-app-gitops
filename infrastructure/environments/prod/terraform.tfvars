# No need to repeat defaults – only override what differs from module defaults
# However, we set critical values explicitly for clarity:

aws_region          = "us-east-1"
availability_zones  = ["us-east-1a", "us-east-1b", "us-east-1c"]
node_instance_types = ["t3.medium"]
node_desired_size   = 2
node_min_size       = 2
node_max_size       = 3
kubernetes_version  = "1.30"
