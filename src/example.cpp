#include <iostream>
#include <vector>
#include "threadPool.h"

int main()
{
    ThreadPool pool(4); // 创建一个有 4 个线程的线程池

    // 提交多个任务
    std::vector<std::future<int>> results;
    for (int i = 0; i < 8; ++i)
    {
        results.emplace_back(pool.commit([i] {
            std::cout << "Task " << i << " is running on thread " << std::this_thread::get_id() << std::endl;
            std::this_thread::sleep_for(std::chrono::seconds(1));
            return i * i;
        }));
    }

    // 获取任务结果
    for (auto &&result : results)
    {
        std::cout << "Result: " << result.get() << std::endl;
    }

    return 0;
}
