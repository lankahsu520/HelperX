# ESP and [FreeRTOS](https://www.freertos.org/index.html)
[![](https://img.shields.io/badge/Powered%20by-lankahsu%20-brightgreen.svg)](https://github.com/lankahsu520/HelperX)
[![GitHub license][license-image]][license-url]
[![GitHub stars][stars-image]][stars-url]
[![GitHub forks][forks-image]][forks-url]
[![GitHub issues][issues-image]][issues-image]
[![GitHub watchers][watchers-image]][watchers-image]

[license-image]: https://img.shields.io/github/license/lankahsu520/HelperX.svg
[license-url]: https://github.com/lankahsu520/HelperX/blob/master/LICENSE
[stars-image]: https://img.shields.io/github/stars/lankahsu520/HelperX.svg
[stars-url]: https://github.com/lankahsu520/HelperX/stargazers
[forks-image]: https://img.shields.io/github/forks/lankahsu520/HelperX.svg
[forks-url]: https://github.com/lankahsu520/HelperX/network
[issues-image]: https://img.shields.io/github/issues/lankahsu520/HelperX.svg
[issues-url]: https://github.com/lankahsu520/HelperX/issues
[watchers-image]: https://img.shields.io/github/watchers/lankahsu520/HelperX.svg
[watchers-url]: https://github.com/lankahsu520/HelperX/watchers

# 1. Overview

> 提供一個較小的作業系統。一般用於MCU。RTOS 的開發要特別注意 ISR 運行中，不要再有 interrupt，且處理時間要短，把耗時的流程移至一般Task。
>
> 本篇是主要是用 Rafael RT58x (ARM Cortex-M3 CPU)。大家手邊的 SDK，會因為 MCU 或供應商不同而有所差異。

## 1.1. [FreeRTOS Real Time Kernel (RTOS)](https://sourceforge.net/projects/freertos/)

> FreeRTOS is a market-leading real-time operating system (RTOS) for microcontrollers and small microprocessors. Distributed freely under the MIT open source license, FreeRTOS includes a kernel and a growing set of libraries suitable for use across all industry sectors. Visit [https://www.freertos.org](https://www.freertos.org/) for more information and other download options.

#### A. Features

- Tiny (5-10kb ROM), power-saving kernel
- Support for 40+ architectures
- Truely free MIT license
- Optional commercial licensing and support available
- Variety of modular libraries included
- Secure and tested IoT reference integrations

## 1.2. [FreeRTOS support forum](https://forums.freertos.org)

# 2. Software and Hardware Layer

## 2.1. Task Priority (High to Low)

> HWI 和 SWI 的執行時間都有嚴格的限制。所以要善用 Queue 或是 Event 傳遞到一般的 Task。
>
> 另外特別注意 ISR  的 Task 要使用 xxxISR()。

```mermaid
flowchart TD
	HWI[HWI 硬體中斷 - Hardware Interrupt / Interrupt Service Routine]
	SWI[SWI 軟體中斷 - Software Interrupt]
	Task[Task / Thread]
	Idle[Idle Task]
	
	HWI --> SWI --> Task --> Idle
```

## 2.2. Task States

![tskstate](./FreeRTOS/tskstate.gif)

## 2.3. Memory Allocation

>ESP 本體是使用 FreeRTOS 沒錯，但是在記憶體管理採用 multi_heap，之間有什麼不同，本人很坦然的承認“不知道”。當然各位手邊的設備，也有可能不是完全使用 FreeRTOS 的記憶體管理方式。
>
>但是軟體開發，沒什麼大道理。只要注意剩餘空間，勿佔用過多的空間而不用，每用完空間後記得釋放即可。就好像開發 linux 的程式時，也不會特別在意其擺放位置，

>以下內容取自於 [Introduction to RTOS - Solution to Part 4 (Memory Management](https://www.digikey.com/en/maker/projects/introduction-to-rtos-solution-to-part-4-memory-management/6d4dfcaa1ff84f57a2098da8e6401d9c)

![Memory Allocation](https://www.digikey.com/maker-media/60c3b8b7-f4af-4a07-b139-0acae5a846fb)

![RTOS Memory Allocation](https://www.digikey.com/maker-media/b9d52446-ebca-4ae5-9e8d-9a4a035d1e4d)

> 以下內容取自於 [Dynamic Memory Management](https://www.codeinsideout.com/blog/freertos/memory/#dynamic-memory-management)

![Memory Heap in RTOS](https://www.codeinsideout.com/blog/freertos/memory/rtos_memory_layout.drawio.svg)

### 2.3.1. HEAP 1,2,3,4,5

> 以下內容取自於 [FreeRTOS Heap_1、Heap_2、Heap_3、Heap_4、Heap_5的区别](https://blog.csdn.net/qq_21513281/article/details/121243362)

> #define configAPPLICATION_ALLOCATED_HEAP 1

#### A. Heap_1

> - [x] configTOTAL_HEAP_SIZE in FreeRTOSConfig.h

> - [x] pvPortMalloc()
> - [ ] vPortFree()

![Heap_1](https://img-blog.csdnimg.cn/450408a0fbf44d1cbf15f40be26a242b.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA6YCD6LeRZGXmnKjlgbY=,size_20,color_FFFFFF,t_70,g_se,x_16)

#### B. Heap_2

> Heap_2 不會整合相鄰的空閒空間，而 Heap_4 可以。所以不同空間大小進行多次 alloc 和 free，會造成空間破碎。

> - [x] configTOTAL_HEAP_SIZE in FreeRTOSConfig.h

> - [x] pvPortMalloc()
> - [x] vPortFree()

![Heap_2](https://img-blog.csdnimg.cn/56b610fdd8374cc5a546293f0ecf810c.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBA6YCD6LeRZGXmnKjlgbY=,size_19,color_FFFFFF,t_70,g_se,x_16)

#### C. Heap_3

> 使用大小將決定於 linker。

> - [ ] configTOTAL_HEAP_SIZE in FreeRTOSConfig.h

> - [x] malloc()
> - [x] free()

#### D. Heap_4

> Heap_4 會整合相鄰的空閒空間，而 Heap_2 不會。
>
> Heap_4 使用空間要連續的區塊，而 Heap_5 使用映射，所以不用。

> - [x] configTOTAL_HEAP_SIZE in FreeRTOSConfig.h

> - [x] pvPortMalloc()
> - [x] vPortFree()
> - [x] malloc()
> - [x] free()

#### E. Heap_5

> Heap_5 使用映射，所以不用連續的空間。

> - [x] configTOTAL_HEAP_SIZE in FreeRTOSConfig.h

> - [x] pvPortMalloc()
> - [x] vPortFree()
> - [x] malloc()
> - [x] free()
> - [x] vPortDefineHeapRegions

### 2.3.2. multi_heap

# 3. [API Reference](https://www.freertos.org/a00106.html)

## 3.1. FreeRTOSConfig.h

> [FreeRTOS学习笔记(3)FreeRTOS的系统配置](https://neyzoter.cn/2018/04/01/FreeRTOS-Note3-Config/)

#### A. configUSE_TASK_NOTIFICATIONS

## 3.2. Task & ISR

> [FreeRTOS --（7）任务管理之入门篇](https://blog.csdn.net/zhoutaopower/article/details/107019521)

```C
xTaskCreateStatic
xTaskCreate
xTaskCreateRestricted
xTaskCreateRestrictedStatic
  
xPortIsInsideInterrupt

TaskHandle_t xHandle = xTaskGetCurrentTaskHandle();
vTaskDelete(xHandle);
```

```c
static void esp_mqtt_task(void *pv)
{
	...
    vTaskDelete(NULL); // kill self
}

esp_err_t esp_mqtt_client_start(esp_mqtt_client_handle_t client)
{
	...
    if (xTaskCreate(esp_mqtt_task, "mqtt_task", client->config->task_stack, client, client->config->task_prio, &client->task_handle) != pdTRUE) {
        ESP_LOGE(TAG, "Error create mqtt task");
        err = ESP_FAIL;
    }
	...
}
```

## 3.3. System Tools

#### log

```c

```

#### memory

```c
uint32_t sys_get_free_size(void)
{
	return (uint32_t)xPortGetFreeHeapSize();
  //heap_caps_get_free_size(MALLOC_CAP_DEFAULT)
}
```

```c
// 目前 task 剩餘 stack 空間
UBaseType_t task_freestack = uxTaskGetStackHighWaterMark(NULL);
```

#### now

```c
// get current system time
uint32_t sys_now(void)
{
  return xTaskGetTickCount() * portTICK_RATE_MS;
}

uint32_t sys_now_from_isr(void)
{
	return xTaskGetTickCountFromISR() * portTICK_RATE_MS;
}
```

#### random

```c
static uint32_t gu32_random_seed = random_seed;

void sys_set_random_seed(uint32_t random_seed)
{
	gu32_random_seed = random_seed;
}
uint32_t sys_random(void)
{
	return sys_now() + gu32_random_seed * 1103515245 + 12345678;
}
```

#### sleep

> 1 (hour) = 60 (min) = 3600 (sec)
>
> 1 (sec) = 1000ms (ms) = 1,000,000 (us) = 1,000,000,000 (ns) = 1,000,000,000 (ps)

```c
void vTaskDelay( const TickType_t xTicksToDelay )

// 必須將 ms 轉成 tick
uint32_t 2secs = 2000 / portTICK_PERIOD_MS // 2 seconds -> ticks
```

```c
void sys_msleep(uint32_t u32_ms)
{
	if (u32_ms >= 1)
	{
		vTaskDelay(u32_ms / portTICK_PERIOD_MS);
	}
}
```

#### task

```bash
const char *taskname = pcTaskGetTaskName(NULL);
```

```c
// 取得目前 task 的數量
uint32_t before_count = uxTaskGetNumberOfTasks();
...
uint32_t after_count = uxTaskGetNumberOfTasks();
```

## 3.4. Event

> [FreeRTOS --（17）任务通知浅析](https://stephenzhou.blog.csdn.net/article/details/107467305)
>
> In FreeRTOSConfig.h, set configUSE_TASK_NOTIFICATIONS  as 1

```c
xTaskNotify
xTaskNotifyAndQuery
xTaskNotifyAndQueryFromISR
  
xTaskNotifyGive
xTaskNotifyFromISR

ulTaskNotifyTake
xTaskNotifyWait
```

```mermaid
sequenceDiagram
	participant TaskA as Task A
	participant xNotify
	participant TaskB as Task B

	TaskA->>xNotify: xTaskNotify
	xNotify->>TaskB: xTaskNotifyWait

```

## 3.5. Mailbox & [Queues](https://www.freertos.org/a00018.html)

> [FreeRTOS --（14）队列管理之概述](https://blog.csdn.net/zhoutaopower/article/details/107221175)

>[ChatGPT] RTOS queue 的功用
>
>
>RTOS（Real-Time Operating System）中的隊列（Queue）是一種用於任務之間通信和數據傳輸的數據結構。隊列允許一個任務（或中斷服務例程）放置數據，而另一個任務從隊列中取出數據。這種通信方式是線程安全的，因此適用於多任務環境。
>
>隊列的主要功能包括：
>
>1. **數據傳輸**：允許一個任務將數據放置到隊列中，而另一個任務從隊列中取出數據，實現了數據在任務之間的傳遞。
>2. **同步**：隊列還可以用於同步任務的執行，例如一個任務等待隊列中有數據可用，另一個任務在隊列中放置數據，這樣就實現了任務之間的同步。
>3. **數據緩沖**：隊列可以用作數據緩沖區，允許任務在不同的速率下生產和消費數據。
>4. **事件通知**：任務可以等待某些特定的事件發生，當事件發生時，將數據放入隊列並通知等待的任務。
>
>總的來說，隊列在RTOS中起著重要的作用，使得任務之間的通信和同步更加簡單和可靠。

```c
xQueueCreate
xQueueCreateStatic

// 刪除 QueueA
vQueueDelete(QueueA);
  
xQueueSend
xQueueSendFromISR
xQueueSendToBack
xQueueSendToBackFromISR
xQueueSendToFront
xQueueSendToFrontFromISR
xQueueCRSend
xQueueCRSendFromISR
xQueueOverwrite

xQueuePeek
xQueuePeekFromISR

// 從 xTimerQueue 接收訊息
while( xQueueReceive( xTimerQueue, &xMessage, tmrNO_DELAY ) != pdFAIL )
{
  ...
}
// ISR 從 QueueA 接收訊息
portBASE_TYPE xTaskWokenByReceive = pdFALSE;
while( xQueueReceiveFromISR( QueueA, ( void *) &cRxedChar, &xTaskWokenByReceive) )
{
	...
}
//
xQueueCRReceiveFromISR
 //
xQueueCRReceive

// 清空 QueueA 裏的資料 
xQueueReset(QueueA);

// 取得 QueueA 的名稱
const char *Qunamename = pcQueueGetName(QueueA);

// 設定 QueueA 的編號
UBaseType_t QueueA_id = 520;
vQueueSetQueueNumber(QueueA, QueueA_id);
// 取得 QueueA 的編號
UBaseType_t QueueA_id = uxQueueGetQueueNumber(QueueA);

// 取得 QueueA 中的待處理的個數
UBaseType_t QueueA_wait_counts = uxQueueMessagesWaiting(QueueA);
// 取得 QueueA 的剩餘空間（個數）
UBaseType_t QueueA_free_spaces = uxQueueSpacesAvailable(QueueA);

// ISR 取得 QueueA 是否為空
if (pdTRUE == xQueueIsQueueEmptyFromISR(QueueA) )
{
	...
}
// ISR 取得 QueueA 是否為滿
if (pdTRUE == xQueueIsQueueFullFromISR(QueueA) )
{
	...
}
  
```

```mermaid
flowchart LR
	subgraph taskA
		queue_t[[queue in task]]
	end
	subgraph taskB
		queue_b[[queue in task]]
	end
	subgraph interrupt
		queue_i[[queue in interrupt]]
	end

	interrupt ..-> |xQueueSendFromISR|queue_t
	queue_b ..-> |xQueueReceiveFromISR|interrupt
	taskB ..-> |xQueueSend|queue_t
	taskA ..-> |xQueueSend|queue_b

	classDef Red     fill:#FF0000
	classDef Yellow  fill:#FFFF00
	class task Yellow
	class interrupt Red

```

## 3.6. Mutex & Semaphore

> [FreeRTOS --（15）信号量之概述](https://stephenzhou.blog.csdn.net/article/details/107359095)
> [FreeRTOS --（16）资源管理之临界区](https://stephenzhou.blog.csdn.net/article/details/107387427)

```c
xSemaphoreCreateBinary
xSemaphoreCreateBinaryStatic

xSemaphoreTake
xSemaphoreTakeRecursive

xSemaphoreGive
xSemaphoreGiveRecursive

xSemaphoreGiveFromISR
xSemaphoreTakeFromISR

xSemaphoreCreateMutex
xSemaphoreCreateMutexStatic
xSemaphoreCreateRecursiveMutex
xSemaphoreCreateRecursiveMutexStatic
xSemaphoreCreateCounting
xSemaphoreCreateCountingStatic

xSemaphoreGetMutexHolder
xSemaphoreGetMutexHolderFromISR
```

#### A. Mutex

> 常用於資源保護

```mermaid
sequenceDiagram
	participant TaskA as Task A
	participant xMutex
	participant TaskB as Task B

	xMutex->>TaskA: xSemaphoreTake
	TaskA->>xMutex: xSemaphoreGive
	xMutex->>TaskB: xSemaphoreTake
	TaskB->>xMutex: xSemaphoreGive
	xMutex->>TaskA: xSemaphoreTake
	TaskA->>xMutex: xSemaphoreGive
```

##### A.1. Main

```c
int main(int argc, char* argv[])
{
  xMutex = xSemaphoreCreateMutex();
}
```

##### A.2. Task A

```C
void TaskA(void *arg)
{
	for( ;; )
	{
		xSemaphoreTake( xMutex, portMAX_DELAY );
		{
			printf("Task A\n");
		}
		xSemaphoreGive( xMutex );
		vTaskDelay( 1000/portTICK_RATE_MS );
	}
}
```

##### A.3. Task B

```C
void TaskB(void *arg)
{
	for( ;; )
	{
		xSemaphoreTake( xMutex, portMAX_DELAY );
		{
			printf("Task B\n");
		}
		xSemaphoreGive( xMutex );
		vTaskDelay( 1000/portTICK_RATE_MS );
	}
}
```

#### B. Semaphore

> 常用於同步

```mermaid
sequenceDiagram
	participant TaskA as Task A
	participant xSemaphore
	participant TaskB as Task B

	TaskA->>xSemaphore: xSemaphoreGive
	xSemaphore->>TaskB: xSemaphoreTake

```

# Appendix

# I. Study

## I.1. [FreeRTOS](http://wiki.csie.ncku.edu.tw/embedded/freertos)

## I.2. [FreeRTOS學習筆記——互斥型信號量](https://www.twblogs.net/a/5b7e42d82b71776838563861)

## I.3. [FreeRTOS学习笔记——二值型信号量](https://blog.csdn.net/xukai871105/article/details/43153177)

## I.4. [FreeRTOS学习笔记——任务间使用队列同步数据](https://blog.csdn.net/xukai871105/article/details/17125627)

## I.5. [RTOS](https://blog.csdn.net/zhoutaopower/category_10073388.html)

## I.6. [FreeRTOS Heap_1、Heap_2、Heap_3、Heap_4、Heap_5的区别](https://blog.csdn.net/qq_21513281/article/details/121243362)

## I.7. [FreeRTOS Heap 1_2_3_4_5 比较](https://www.cnblogs.com/FutureHardware/p/14220238.html)

# II. Debug

# III. Glossary

#### TCB, Task Control Block

>[ChatGPT] FreeRTOS 的 TCB 功用
>
>FreeRTOS 中的 TCB 是任務控制塊（Task Control Block）的縮寫，用於存儲任務的運行時信息。每個任務都有一個對應的 TCB，TCB 中包含了任務的狀態、優先級、堆棧指針等信息。通過 TCB，FreeRTOS 可以管理任務的執行，包括任務的創建、刪除、掛起、恢覆等操作。
>
>TCB 的主要作用包括：
>
>1. 存儲任務的運行時信息：包括任務的狀態（運行、就緒、掛起等）、優先級、堆棧指針、任務名字等。
>2. 任務調度：FreeRTOS 根據任務的優先級和狀態，使用 TCB 來進行任務的調度，確保高優先級任務可以優先執行。
>3. 任務管理：通過 TCB，可以實現對任務的創建、刪除、掛起、恢覆等操作，以及獲取任務的運行時信息。
>
>總的來說，TCB 是 FreeRTOS 中管理任務的重要數據結構，它承載了任務的關鍵信息，為任務的管理和調度提供了基礎。

# IV. Tool Usage

# Author

> Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

> [HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.
