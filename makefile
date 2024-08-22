SRC_DIR = ./src
BUILD_DIR = ./build
TARGET = $(BUILD_DIR)/example

CC = g++
CFLAGS = -Wall

# ./src/*.cpp
SRCS = $(shell find $(SRC_DIR) -name '*.cpp')
# ./src/*.cpp => ./build/*.o
OBJS = $(patsubst $(SRC_DIR)/%.cpp,$(BUILD_DIR)/%.o,$(SRCS))
# ./src/*.cpp => ./build/*.d
DEPS = $(patsubst $(SRC_DIR)/%.cpp,$(BUILD_DIR)/%.d,$(SRCS))

# 默认目标:
all: $(TARGET)

# build/xyz.d 的规则由 src/xyz.cpp 生成:
$(BUILD_DIR)/%.d: $(SRC_DIR)/%.cpp
	@mkdir -p $(dir $@); \
	rm -f $@; \
	$(CC) -MM $< >$@.tmp; \
	sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.tmp > $@; \
	rm -f $@.tmp

# build/xyz.o 的规则由 src/xyz.cpp 生成:
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c -o $@ $<

# 链接:
$(TARGET): $(OBJS)
	@echo "buiding $@..."
	@mkdir -p $(dir $@)
	$(CC) -o $(TARGET) $(OBJS) -lpthread

# 清理 build 目录:
clean:
	@echo "clean..."
	rm -rf $(BUILD_DIR)

# 引入所有 .d 文件:
-include $(DEPS)