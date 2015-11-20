#include <iostream>           // std::cout
#include <thread>             // std::thread
#include <mutex>              // std::mutex, std::unique_lock
#include <condition_variable> // std::condition_variable
#include <cassert>
#include <chrono>

using namespace std;
struct Queue {
  mutex mt;
  condition_variable_any producer_signal, consumer_signal;
  int begin, end;
  int array[1000];
};
int calculer(int ret,int ite){
        cout << ret << "   " << ite << endl;
	if(ret == 1)
		return ite;
	else{
		if(ret % 2 == 0)
			ret = ret/2;
		else
			ret = ret*3+1;
		ite = ite + 1;
		calculer(ret,ite);
	}
	return 0;
}
void push(Queue & q, int val) {
  q.mt.lock();
  while(q.end - q.begin == 99) {
    q.producer_signal.wait(q.mt);
  }
  int index = q.end % 100;
  q.array[index] = val;
  q.end = q.end + 1;
  assert(q.begin <= q.end);
  assert(q.end - q.begin <= 99);
  q.consumer_signal.notify_all();
  q.mt.unlock();
}
int pull(Queue & q) {
  q.mt.lock();
  
  while(q.begin == q.end) {
    q.consumer_signal.wait(q.mt);
  }
  int index = q.begin % 100;
  int res = q.array[index];
  q.begin = q.begin + 1;
  assert(q.begin <= q.end);
  assert(q.end - q.begin <= 99);
  if(q.end - q.begin <= 50) {
    q.producer_signal.notify_all();
  }
  q.mt.unlock();
return res;
}

int  size(Queue & q) {
  q.mt.lock();
  int res = q.end - q.begin;
  assert(q.begin <= q.end);
  assert(q.end - q.begin <= 99);
  q.mt.unlock();
  return res;
}

bool is_empty(Queue & q) {
  q.mt.lock();
  bool res = q.begin == q.end;
  assert(q.begin <= q.end);
  assert(q.end - q.begin <= 99);
  q.mt.unlock();
  return res;
}

void producer (Queue & q, int id) {
  this_thread::sleep_for(chrono::nanoseconds(100));
  for(int i = 0; i < 1000; i++) {
    this_thread::sleep_for(chrono::nanoseconds(10));
    //cout << "P[" << id << "]:\t" << i << endl;
    //cout << "P[" << id << "]:\t" << i << endl;
    cout << id;
    push(q, i);
  }
}
void consumerA (Queue & q, Queue & qf,int id) {
  while(true) {
    this_thread::sleep_for(chrono::nanoseconds(5));
    int res = pull(q);
    int ret = calculer(res,0);
   // cout << "A";
    //cout << "C[" << id << "]:\t" << pull(q) << endl;
     push(qf,ret);
}
}
void consumerB (Queue & q, Queue & qf,int id) {
  while(true) {
    this_thread::sleep_for(chrono::nanoseconds(5));
    int res = pull(q);
    int ret = calculer(res,0);
    //cout << "B";
    //cout << "C[" << id << "]:\t" << pull(q) << endl;
	push(qf, ret);
  }
}

void consumerC (Queue & q,Queue & qf,int id) {
  while(true) {
    this_thread::sleep_for(chrono::nanoseconds(5));
    int res = pull(q);
    int ret = calculer(res,0);
    //cout << "C";
    //cout << "C[" << id << "]:\t" << pull(q) << endl;
    push(qf,ret);
  }
}
int main () {
  Queue q;
  q.begin = 0;
  q.end = 0;
  Queue qf;
  qf.begin = 0;
  qf.end = 0;

  thread p = thread(producer, ref(q), 0);
  thread p1 = thread(producer, ref(q), 1);
  thread p2 = thread(producer, ref(q), 2);
  thread p3 = thread(producer, ref(q), 3);
  thread p4 = thread(producer, ref(q), 4);
  thread a = thread(consumerA, ref(q), ref(qf),0);
  thread b = thread(consumerB, ref(q),ref(qf),0);
  thread c = thread(consumerC, ref(q),ref(qf),0);
  p.join();
  c.join();
  return 0;
}
