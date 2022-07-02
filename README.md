# Description here

# Useful commands
- Before deleting cluster all services need to be deleted so LB's can be cleaned up:
```bash
k get svc -A | awk '{print $2}' | xargs -I{} kubectl delete svc/{}
- Dangling ENI's might also prevent TF destroy
```
