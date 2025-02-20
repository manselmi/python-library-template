// vim: set ft=groovy :


pipeline {
  agent {
    node {
      label 'manylinux_2_28_aarch64'
    }
  }
  environment {
    NO_COLOR = '1'
    NO_DEPLOY = '1'
    PIP_PROGRESS_BAR = 'off'
    PIP_ROOT_USER_ACTION = 'ignore'
    PRE_COMMIT_COLOR = 'never'
    TOX_PARALLEL_NO_SPINNER = '1'
    _PATH = "/opt/python/cp313-cp313/bin:/opt/python/cp312-cp312/bin:/opt/python/cp311-cp311/bin:/opt/python/cp310-cp310/bin:/opt/python/cp39-cp39/bin:${env.PATH}"
  }
  options {
    buildDiscarder(logRotator(daysToKeepStr: '7'))
    timeout(time: 15, unit: 'MINUTES')
  }
  stages {
    stage('init') {
      steps {
        // sh 'dnf --assumeyes --setopt=install_weak_deps=False -- install git'
        sh 'git config --global --add safe.directory "*"'
        sh 'git config --global user.name Jenkins'
        sh 'git config --global user.email jenkins@manselmi.com'
        sh 'env -- PATH="${_PATH}" python -m pip install --upgrade -- pip setuptools wheel'
        sh 'env -- PATH="${_PATH}" python -m pip install --upgrade -- build cookiecutter pkginfo pre-commit tox twine'
      }
    }
    stage('build') {
      steps {
        sh 'env -- PATH="${_PATH}" ./build.sh'
      }
    }
    // stage('deploy') {
    //   when {
    //     branch 'main'
    //   }
    //   steps {
    //     withCredentials([usernamePassword(credentialsId: '00000000-0000-0000-0000-000000000000', passwordVariable: 'TWINE_PASSWORD', usernameVariable: 'TWINE_USERNAME')]) {
    //       sh 'env -- PATH="${_PATH}" ./deploy.sh'
    //     }
    //   }
    // }
  }
  post {
    always {
      junit(allowEmptyResults: true, testResults: 'output/report/junit/*.xml')
      cleanWs()
    }
  }
}
