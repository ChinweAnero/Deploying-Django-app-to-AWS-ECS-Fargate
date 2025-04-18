output "name_of_cluster" {
  value       = aws_ecs_cluster.cluster.name
  description = "outputs cluster name"
}
output "cluster_id" {
  value = aws_ecs_cluster.cluster.id
  description = "outputs the id of the cluster"
}