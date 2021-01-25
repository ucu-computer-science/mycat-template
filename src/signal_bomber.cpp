// This is a personal academic project. Dear PVS-Studio, please check it.
// PVS-Studio Static Code Analyzer for C, C++ and C#: http://www.viva64.com

#include <iostream>
#include <sys/wait.h>
#include <unistd.h>
#include <signal.h>

int main(int argc, char *argv[]) {
    pid_t pid = fork();
    if (pid == -1) {
        std::cerr << "Failed to fork()" << std::endl;
        exit(EXIT_FAILURE);
    } else if (pid > 0) {
        int status;
        while (!waitpid(pid, &status, WNOHANG)) {
            kill(pid, SIGCONT);
            kill(pid, SIGURG);
            kill(pid, SIGCHLD);
            kill(pid, SIGWINCH);
        }
        return WEXITSTATUS(status);
    } else {
        execvp(argv[1], &(argv[1]));
        std::cerr << "Child: Failed to execute " << argv[1] << " \n\tCode: " << errno << std::endl;
        exit(EXIT_FAILURE);
    }
}
