import subprocess
import yaml

def parseYaml(path: str) -> dict:
    d = {}
    with open(path, 'r') as f:
        d = yaml.load(f, Loader=yaml.FullLoader)
    return d

def getUrl(var: dict, key: str) -> str:
    dn = var['base']['envoy']['domain']
    i = var[key]['external'].find('.')
    sd = var[key]['external'][0:i]
    return 'https://{}.{}'.format(sd, dn)

def makeSSHCommand() -> list:
    host = inv['cluster']['hosts']['cp0']['ansible_host']
    user = inv['cluster']['hosts']['cp0']['ansible_user']
    ssharg = []
    if inv['cluster']['hosts']['cp0'].get('ansible_ssh_common_args'):
        ssharg = inv['cluster']['hosts']['cp0']['ansible_ssh_common_args'].split()
    return ['ssh'] + ssharg + [user + '@' + host]

def genDashboardToekn(inv: dict) -> str:
    # Make ssh command
    ssh = makeSSHCommand()
    # Generate secret which will be used to delete generating token
    cmd = ssh + ['kubectl', 'delete', 'secret', '-n', 'kubernetes-dashboard', 'admin-user-secret']
    subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate() # Ignore stdout and stderr
    cmd = ssh + ['kubectl', 'create', 'secret', '-n', 'kubernetes-dashboard', 'generic', 'admin-user-secret']
    subprocess.Popen(cmd, stdout=subprocess.PIPE).communicate()
    # Generate token, which has 100years lifetime, binded with the secret
    cmd = ssh + ['kubectl', 'create', 'token', '-n', 'kubernetes-dashboard', 'admin-user', '--duration', '876000h', '--bound-object-kind', 'Secret', '--bound-object-name', 'admin-user-secret']
    stdout, _ = subprocess.Popen(cmd, stdout=subprocess.PIPE).communicate()
    return stdout.decode('utf-8')

def getArgoCDSecret(inv: dict) -> str:
    # Make ssh command
    ssh = makeSSHCommand()
    # Get the secret
    cmd = ssh + ['kubectl', 'get', 'secret', '-n', 'argocd', 'argocd-initial-admin-secret', '-o', 'jsonpath="{.data.password}"', '|', 'base64', '-d']
    stdout, _ = subprocess.Popen(cmd, stdout=subprocess.PIPE).communicate()
    return stdout.decode('utf-8')

if __name__ == '__main__':
    inv = parseYaml('inventories/vbox.yaml')
    var = parseYaml('playbooks/vars.yaml')
    # Show DNS Info
    print('[DNS]')
    print(' |_ IP:', inv['dns']['hosts']['dns0']['ansible_host'])
    # Show registry info
    print('[REGISTRY]')
    print(' |_ URL:', getUrl(var, 'harbor'))
    print(' |_ Admin ID:', 'admin')
    print(' |_ Admin PW:', var['base']['harbor']['pw'])
    # Show SCM info
    print('[SCM]')
    print(' |_ URL:', getUrl(var, 'gitea'))
    print(' |_ Admin ID:', var['base']['gitea']['admin_id'])
    print(' |_ Admin PW:', var['base']['gitea']['admin_pw'])
    print(' |_ User jenkins ID:', var['base']['gitea']['jenkins_id'])
    print(' |_ User jenkins PW:', var['base']['gitea']['jenkins_pw'])
    # Show CI info
    print('[CI]')
    print(' |_ URL:', getUrl(var, 'jenkins'))
    print(' |_ Admin ID: admin')
    with open('playbooks/.keep/jenkins-admin-pw', 'r') as f:
        print(' |_ Admin PW:', f.read(), end='')
    # Show K8s info
    print('[K8s]')
    print(' |_ Dashboard IP:', var['base']['dashboard']['ip'])
    print(' |_ Dashboard Token: Generating... (Old one will be expired)')
    print(genDashboardToekn(inv))
    print(' |_ Argo CD IP:', var['base']['argocd']['ip'])
    print(' |_ Argo CD Admin ID: admin')
    print(' |_ Argo CD Admin PW:', getArgoCDSecret(inv))

