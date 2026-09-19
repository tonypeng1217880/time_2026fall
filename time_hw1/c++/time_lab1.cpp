#include <iostream>
#include <iomanip>
#include <cstdint>

// Hardware SQR algorithm (Successive Approximation)
uint16_t hardware_sqrt(uint16_t x) {
    uint16_t y = 0;
    uint32_t target = (uint32_t)x << 9; 

    for (int i = 9; i >= 0; i--) {
        uint16_t temp_y = y | (1 << i);
        uint32_t sq = (uint32_t)temp_y * temp_y;
        
        if (sq <= target) {
            y = temp_y;
        }
    }
    return y;
}

// Hardware X^(2/3) algorithm (Bonus)
uint16_t hardware_pow_2_3(uint16_t x) {
    uint16_t y = 0;
    uint64_t target = (uint64_t)x * x; 
    
    target = target << 12; 

    for (int i = 9; i >= 0; i--) {
        uint16_t temp_y = y | (1 << i);
        uint64_t cube = (uint64_t)temp_y * temp_y * temp_y;
        
        if (cube <= target) {
            y = temp_y;
        }
    }
    return y;
}

void test_module(double input) {
    uint16_t x_hw = (uint16_t)(input * 8.0);
    
    uint16_t y_sqrt_hw = hardware_sqrt(x_hw);
    uint16_t y_bonus_hw = hardware_pow_2_3(x_hw);
    
    double y_sqrt = y_sqrt_hw / 64.0;
    double y_bonus = y_bonus_hw / 64.0;
    
    std::cout << "Input (x): " << std::fixed << std::setprecision(3) << input 
              << " (HW Hex In: 0x" << std::hex << x_hw << std::dec << ")\n";
    std::cout << "  -> SQR(x): " << y_sqrt 
              << " (HW Hex Out: 0x" << std::hex << y_sqrt_hw << std::dec << ")\n";
    std::cout << "  -> x^(2/3): " << y_bonus 
              << " (HW Hex Out: 0x" << std::hex << y_bonus_hw << std::dec << ")\n";
    std::cout << "--------------------------------------------------\n";
}

int main() {
    double inputs[] = {4.0, 16.125, 49.5};
    for (double in : inputs) {
        test_module(in);
    }
    return 0;
}